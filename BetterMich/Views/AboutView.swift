import SwiftData
import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataStore: MichelinDataStore
    @Query private var states: [RestaurantState]
    @AppStorage("aboutLegendMode") private var legendModeRawValue: String = LegendMode.legend.rawValue

    var body: some View {
        let counts: [LegendCategory: LegendCount] =
            legendMode == .visited ? legendCounts() : [:]

        NavigationStack {
            ScrollView {

                Image(.taiwanMich)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)

                Text("米台目")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 2)

                Text("Version \(Version)")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))

                Text("資料月份：\(dataStore.latestYearMonth ?? "未知")")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))

                VStack(spacing: 4) {
                    Button {
                        Task { await dataStore.refresh() }
                    } label: {
                        Text("抓取最新資料")
                            .font(.caption)
                    }
                    .opacity(dataStore.isLoading ? 0 : 1)
                    .overlay {
                        if dataStore.isLoading {
                            ProgressView()
                        }
                    }
                    Text("已是最新資料")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                        .opacity(dataStore.isLatest ? 1 : 0)
                }
                .padding(.top, 4)

                Divider().padding()

                HStack(spacing: 8) {
                    Button {
                        legendModeRawValue = LegendMode.legend.rawValue
                    } label: {
                        Text("圖例")
                            .foregroundStyle(
                                legendMode == .legend ? .primary : .secondary
                            )
                    }
                    .buttonStyle(.plain)

                    Divider()
                        .overlay(Color(.darkGray))

                    Button {
                        legendModeRawValue = LegendMode.visited.rawValue
                    } label: {
                        Text("造訪")
                            .foregroundStyle(
                                legendMode == .visited ? .primary : .secondary
                            )
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                .font(.title)
                .padding(.bottom, 5)

                VStack(alignment: .center, spacing: 7) {
                    HStack {
                        DistinctionView(
                            distinction: 3,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.stars(3), fallback: "三星", counts: counts))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 2,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.stars(2), fallback: "二星", counts: counts))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 1,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.stars(1), fallback: "一星", counts: counts))
                    }

                    HStack {
                        Image("mich.greenstar")
                            .foregroundStyle(.green)
                        Spacer()
                        Text(legendText(.sustainable, fallback: "綠星", counts: counts))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 0,
                            bibendum: true,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.bibendum, fallback: "必比登", counts: counts))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 0,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.recommended, fallback: "入選", counts: counts))
                    }
                }
                .padding(.trailing, 120)
                .padding(.leading, 120)

                Divider().padding()

                Text("本 App 所提供的所有資訊皆來自：")
                    .font(.subheadline)
                    .padding(.bottom, 3)

                Link(
                    "台灣米其林官網\(Image(systemName: "arrow.up.forward.app.fill"))",
                    destination: URL(
                        string: MichelinURL
                    )!
                )
                .font(.headline)

                Spacer()

            }
            .navigationBarItems(
                trailing: Button("完成") {
                    dismiss()
                }
            )
        }

    }

}

extension AboutView {
    fileprivate enum LegendMode: String {
        case legend
        case visited
    }

    fileprivate enum LegendCategory: Hashable {
        case stars(Int)
        case sustainable
        case bibendum
        case recommended
    }

    fileprivate struct LegendCount {
        var total = 0
        var visited = 0
    }

    fileprivate func legendText(
        _ category: LegendCategory,
        fallback: String,
        counts: [LegendCategory: LegendCount]
    ) -> String {
        guard legendMode == .visited else { return fallback }
        let count = counts[category] ?? LegendCount()
        return "\(count.visited) / \(count.total)"
    }

    fileprivate func legendCounts() -> [LegendCategory: LegendCount] {
        let categories: [LegendCategory] = [
            .stars(3),
            .stars(2),
            .stars(1),
            .sustainable,
            .bibendum,
            .recommended
        ]
        let visitedIds = Set(
            states
                .filter { $0.isVisited }
                .map { $0.restaurantKey }
        )
        var counts = Dictionary(
            uniqueKeysWithValues: categories.map { ($0, LegendCount()) }
        )
        for restaurant in dataStore.restaurants {
            for category in categories where matchesCategory(restaurant, category: category) {
                counts[category, default: LegendCount()].total += 1
                if visitedIds.contains(restaurant.id) {
                    counts[category, default: LegendCount()].visited += 1
                }
            }
        }
        return counts
    }

    fileprivate func matchesCategory(
        _ restaurant: Restaurant,
        category: LegendCategory
    ) -> Bool {
        switch category {
        case .stars(let count):
            return restaurant.Distinction == count
        case .sustainable:
            return restaurant.Sustainable
        case .bibendum:
            return restaurant.Bibendum
        case .recommended:
            return restaurant.Distinction == 0
                && !restaurant.Bibendum
                && !restaurant.Sustainable
        }
    }
}

private extension AboutView {
    var legendMode: LegendMode {
        LegendMode(rawValue: legendModeRawValue) ?? .legend
    }
}

#Preview {
    AboutView()
        .environmentObject(MichelinDataStore())
        .modelContainer(for: RestaurantState.self, inMemory: true)
}
