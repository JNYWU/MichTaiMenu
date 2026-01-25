import SwiftUI

struct AwardHistoryDialog: View {
    let awardHistory: [AwardHistoryEntry]

    var body: some View {
        let entries = awardHistory.sorted {
            (Int($0.year) ?? 0) < (Int($1.year) ?? 0)
        }
        VStack(alignment: .leading, spacing: 12) {
            Text("評鑑歷史")
                .font(.headline)
            if entries.isEmpty {
                Text("尚無歷史資料")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(entries, id: \.self) { entry in
                    HStack(spacing: 6) {
                        Text("\(entry.year)：")
                            .font(.subheadline.weight(.semibold))
                        Text("\(entry.distinction)")
                        DistinctionView(
                            distinction: entry.distinction,
                            bibendum: entry.bibendum,
                            sustainable: entry.sustainable
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(width: 240)
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
