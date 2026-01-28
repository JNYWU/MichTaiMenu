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
        loadFromCache()
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
            saveCache(payload)
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func loadFromCache() {
        guard let data = try? Data(contentsOf: cacheURL) else { return }
        guard let payload = try? JSONDecoder().decode(MichelinPayload.self, from: data) else { return }
        let hasHistory = payload.restaurants.contains {
            !($0.awardHistory?.isEmpty ?? true)
        }
        guard hasHistory else { return }
        restaurants = restaurantsFromPayload(payload)
        latestYearMonth = yearMonthString(from: payload.etl_dtm)
    }

    private func saveCache(_ payload: MichelinPayload) {
        if let data = try? JSONEncoder().encode(payload) {
            try? data.write(to: cacheURL, options: [.atomic])
        }
    }
}
