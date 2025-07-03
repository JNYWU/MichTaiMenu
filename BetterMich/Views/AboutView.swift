import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) var dismiss

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

                Text("資料年份：2023")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))

                Divider().padding()

                Text("圖例")
                    .font(.title)
                    .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        DistinctionView(distinction: 3, bibendum: false, sustainable: false)
                        Spacer()
                        Text("三星")
                    }
                    HStack {
                        DistinctionView(distinction: 2, bibendum: false, sustainable: false)
                        Spacer()
                        Text("二星")
                    }
                    HStack {
                        DistinctionView(distinction: 1, bibendum: false, sustainable: false)
                        Spacer()
                        Text("一星")
                    }

                    HStack {
                        Image(.greenstar)
                            .foregroundStyle(.green)
                        Spacer()
                        Text("綠星")
                    }
                    HStack {
                        DistinctionView(distinction: 0, bibendum: true, sustainable: false)
                        Spacer()
                        Text("必比登")
                    }
                    HStack {
                        DistinctionView(distinction: 0, bibendum: false, sustainable: false)
                        Spacer()
                        Text("推薦")
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
                        string: MichelinURL)!
                )
                .font(.headline)

                Spacer()

            }
            .navigationBarItems(
                trailing: Button("完成") {
                    dismiss()
                })
        }

    }

}

#Preview {
    AboutView()
}
