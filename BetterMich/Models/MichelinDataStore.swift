import Foundation
import Combine

@MainActor
final class MichelinDataStore: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var latestYearMonth: String?
    @Published var isLoading = false
    @Published var loadError: String?
    @Published var isLatest = false
    @Published private(set) var hasLoaded = false
    private let cacheURL: URL = {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("michelin_cache.json")
    }()

    func loadIfNeeded() async {
        if hasLoaded { return }
        defer { hasLoaded = true }
        await loadFromCache()
        if restaurants.isEmpty {
            await refresh()
        }
    }

    func refresh() async {
        isLoading = true
        loadError = nil
        isLatest = false
        defer { isLoading = false }
        do {
            let previousYearMonth = latestYearMonth
            let payload = try await fetchRemotePayload()
            restaurants = restaurantsFromPayload(payload)
            let currentYearMonth = yearMonthString(from: payload.etl_dtm)
            latestYearMonth = currentYearMonth
            isLatest =
                previousYearMonth != nil
                && previousYearMonth == currentYearMonth
            await saveCache(payload)
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func loadFromCache() async {
        guard let payload = await MichelinCache.loadPayload(from: cacheURL) else {
            return
        }
        restaurants = restaurantsFromPayload(payload)
        latestYearMonth = yearMonthString(from: payload.etl_dtm)
    }

    private func saveCache(_ payload: MichelinPayload) async {
        await MichelinCache.save(payload, to: cacheURL)
    }
}

private enum MichelinCache {
    static func loadPayload(from cacheURL: URL) async -> MichelinPayload? {
        await Task.detached(priority: .utility) {
            guard let data = try? Data(contentsOf: cacheURL),
                  let payload = try? JSONDecoder().decode(
                    MichelinPayload.self,
                    from: data
                  )
            else {
                return nil
            }
            let hasHistory = payload.restaurants.contains {
                !($0.awardHistory?.isEmpty ?? true)
            }
            return hasHistory ? payload : nil
        }.value
    }

    static func save(_ payload: MichelinPayload, to cacheURL: URL) async {
        await Task.detached(priority: .utility) {
            if let data = try? JSONEncoder().encode(payload) {
                try? data.write(to: cacheURL, options: [.atomic])
            }
        }.value
    }
}
