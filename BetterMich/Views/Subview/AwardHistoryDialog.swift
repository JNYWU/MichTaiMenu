import SwiftUI

struct AwardHistoryDialog: View {
    let awardHistory: [AwardHistoryEntry]
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        let entries = awardHistory.sorted {
            (Int($0.year) ?? 0) < (Int($1.year) ?? 0)
        }
        VStack(alignment: .center, spacing: 12) {
            Text("評鑑歷史")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            if entries.isEmpty {
                Text("尚無歷史資料")
                    .foregroundStyle(.secondary)
            } else {
                Grid(horizontalSpacing: 6, verticalSpacing: 8) {
                    ForEach(entries.indices, id: \.self) { index in
                        let entry = entries[index]
                        let previousEntry = index > 0 ? entries[index - 1] : nil
                        GridRow {
                            Text(entry.year)
                                .font(.subheadline.weight(.semibold))
                            Image(
                                systemName: trendIconName(
                                    current: entry,
                                    previous: previousEntry
                                )
                            )
                            .font(.subheadline.weight(.semibold))
                            DistinctionView(
                                distinction: entry.distinction,
                                bibendum: entry.bibendum,
                                sustainable: entry.sustainable
                            )
                            .gridCellAnchor(.leading)
                        }
                    }
                }
                .gridColumnAlignment(.leading)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(minWidth: 240)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: AwardHistoryDialogHeightKey.self,
                        value: proxy.size.height
                    )
            }
        )
        .onPreferenceChange(AwardHistoryDialogHeightKey.self) { height in
            contentHeight = height
        }
        .frame(height: contentHeight == 0 ? nil : contentHeight)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private func trendIconName(
    current: AwardHistoryEntry,
    previous: AwardHistoryEntry?
) -> String {
    guard let previous else { return "minus" }
    let currentRank = awardRank(for: current)
    let previousRank = awardRank(for: previous)
    if currentRank > previousRank {
        return "arrow.up.right"
    }
    if currentRank < previousRank {
        return "arrow.down.right"
    }
    return "minus"
}

private func awardRank(for entry: AwardHistoryEntry) -> Int {
    if entry.distinction > 0 {
        return 100 + entry.distinction
    }
    if entry.bibendum {
        return 50
    }
    return 0
}

private struct AwardHistoryDialogHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    AwardHistoryDialog(
        awardHistory: [
            AwardHistoryEntry(
                year: "2018",
                distinction: 1,
                bibendum: false,
                sustainable: false
            ),
            AwardHistoryEntry(
                year: "2019",
                distinction: 2,
                bibendum: false,
                sustainable: false
            ),
            AwardHistoryEntry(
                year: "2021",
                distinction: 3,
                bibendum: false,
                sustainable: false
            ),
            AwardHistoryEntry(
                year: "2023",
                distinction: 2,
                bibendum: false,
                sustainable: false
            ),
            AwardHistoryEntry(
                year: "2024",
                distinction: 0,
                bibendum: false,
                sustainable: false
            )
        ]
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
