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
                    ForEach(entries, id: \.self) { entry in
                        GridRow {
                            Text(entry.year)
                                .font(.subheadline.weight(.semibold))
                            Text("：")
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
                sustainable: false,
                rawAwardText: "一星：高品質烹飪"
            ),
            AwardHistoryEntry(
                year: "2019",
                distinction: 2,
                bibendum: false,
                sustainable: false,
                rawAwardText: "二星：卓越烹飪"
            ),
            AwardHistoryEntry(
                year: "2023",
                distinction: 3,
                bibendum: false,
                sustainable: false,
                rawAwardText: "三星：卓越烹飪"
            )
        ]
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
