import SwiftData
import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataStore: MichelinDataStore
    @Query private var states: [RestaurantState]
    @State private var legendMode: LegendMode = .legend

    var body: some View {

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

                if dataStore.isLoading {
                    ProgressView()
                        .padding(.top, 4)
                } else if dataStore.isLatest {
                    Text("已是最新資料")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(.top, 4)
                } else {
                    Button {
                        Task { await dataStore.refresh() }
                    } label: {
                        Text("抓取最新資料")
                            .font(.caption)
                    }
                    .padding(.top, 4)
                }

                Divider().padding()

                HStack(spacing: 8) {
                    Button {
                        legendMode = .legend
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
                        legendMode = .visited
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
                        Text(legendText(.stars(3), fallback: "三星"))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 2,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.stars(2), fallback: "二星"))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 1,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.stars(1), fallback: "一星"))
                    }

                    HStack {
                        Image(.greenstar)
                            .foregroundStyle(.green)
                        Spacer()
                        Text(legendText(.sustainable, fallback: "綠星"))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 0,
                            bibendum: true,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.bibendum, fallback: "必比登"))
                    }
                    HStack {
                        DistinctionView(
                            distinction: 0,
                            bibendum: false,
                            sustainable: false
                        )
                        Spacer()
                        Text(legendText(.recommended, fallback: "推薦"))
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
    fileprivate enum LegendMode {
        case legend
        case visited
    }

    fileprivate enum LegendCategory {
        case stars(Int)
        case sustainable
        case bibendum
        case recommended
    }

    fileprivate func legendText(_ category: LegendCategory, fallback: String)
        -> String
    {
        guard legendMode == .visited else { return fallback }
        let total = totalCount(category)
        let visited = visitedCount(category)
        return "\(visited) / \(total)"
    }

    fileprivate func totalCount(_ category: LegendCategory) -> Int {
        dataStore.restaurants.filter { matchesCategory($0, category: category) }
            .count
    }

    fileprivate func visitedCount(_ category: LegendCategory) -> Int {
        let names = Set(
            dataStore.restaurants
                .filter { matchesCategory($0, category: category) }
                .map { $0.Name }
        )
        return states.filter {
            $0.isVisited && names.contains($0.restaurantKey)
        }.count
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

#Preview {
    AboutView()
        .environmentObject(MichelinDataStore())
        .modelContainer(for: RestaurantState.self, inMemory: true)
}
