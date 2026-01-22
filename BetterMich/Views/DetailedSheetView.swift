import MapKit
import SwiftUI

struct DetailedSheetView: View {

    var restaurant: Restaurant
    private let sectionHorizontalPadding: CGFloat = 12
    private let sectionVerticalPadding: CGFloat = 8

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                //MARK: 圖片
                HStack(alignment: .top) {

                    // show image
                    AsyncImage(url: URL(string: restaurant.IMG)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "exclamationmark.icloud")
                        } else {
                            ZStack {
                                Color(.systemGray4)
                                ProgressView()
                            }
                        }

                    }
                    .frame(width: 120, height: 120)
                    .cornerRadius(20)
                    .padding(.trailing, 20)

                    //MARK: 城市、評鑑等級
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(restaurant.City)
                                .font(.title3)

                            Text(restaurant.RestaurantType)
                                .font(.title3)
                        }

                        HStack(spacing: 6) {
                            DistinctionView(
                                distinction: restaurant.Distinction,
                                bibendum: restaurant.Bibendum,
                                sustainable: restaurant.Sustainable
                            )
                            .font(.title2)
                            if restaurant.IsNew {
                                HStack(spacing: 4) {
                                    Image(systemName: "sparkles.2")
                                    Text("新入選")
                                }
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.trailing, 4)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .glassChip()
                            }
                        }

                        HStack {

                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
                .padding(.horizontal, sectionHorizontalPadding)
                .padding(.vertical, sectionVerticalPadding)

                Divider()
                    .padding(.horizontal, sectionHorizontalPadding)
                    .padding(.vertical, sectionVerticalPadding)

                //MARK: 餐廳簡介
                VStack(alignment: .leading, spacing: 5) {
                    Label("餐廳簡介", systemImage: "doc.append")
                        .font(.headline)
                    Text(restaurant.Description)

                    Divider()
                        .padding(.vertical, 12)

                    HStack(alignment: .top) {
                        //MARK: 電話
                        VStack(alignment: .leading, spacing: 6) {
                            Label("電話", systemImage: "phone")
                                .font(.headline)

                            if restaurant.Phone.first == "+" {
                                Text(restaurant.Phone)

                                // call button
                                Button {
                                    let formattedphone = FormatPhoneNumber(
                                        phone: restaurant.Phone
                                    )
                                    guard let url = URL(string: formattedphone)
                                    else { return }

                                    // open phone app and call the number
                                    UIApplication.shared.open(url)

                                } label: {
                                    HStack {
                                        Image(
                                            systemName:
                                                "phone.arrow.up.right.fill"
                                        )
                                        Text("撥號")
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .foregroundStyle(.green)
                                .buttonStyle(.bordered)
                                .tint(.green)
                                .glassChip()
                                .padding(.horizontal, 5)

                            } else {
                                Text("無號碼")
                            }

                        }
                        .frame(
                            minWidth: /*@START_MENU_TOKEN@*/
                                0 /*@END_MENU_TOKEN@*/,
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                        Divider()
                        
                        //MARK: 地址
                        VStack(alignment: .leading, spacing: 6) {
                            Label("地址", systemImage: "map")
                                .font(.headline)
                            Text(FormatAddress(address: restaurant.Address))
                        }
                        .frame(
                            minWidth: /*@START_MENU_TOKEN@*/
                                0 /*@END_MENU_TOKEN@*/,
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    }
                }
                .padding(.horizontal, sectionHorizontalPadding)
                .padding(.vertical, sectionVerticalPadding)

                Divider()
                    .padding(.horizontal, sectionHorizontalPadding)
                    .padding(.vertical, sectionVerticalPadding)
                
                //MARK: 地圖
                MapView(restaurant: restaurant)

            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(restaurant.Name)
                    .font(.title3).bold()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailedSheetView(
            restaurant: Restaurant(
                id: 1,
                name: "示範餐廳",
                distinction: 1,
                sustainable: false,
                bibendum: false,
                isNew: true,
                city: "台北",
                restaurantType: "現代料理",
                phone: "+886 2 1234 5678",
                img:
                    "https://axwwgrkdco.cloudimg.io/v7/__gmpics3__/a2d64509aac140db8f1dee827c7ffa1c.jpeg?width=1000",
                address: "台北市中正區",
                description: "示範用餐廳描述"
            )
        )
    }
}
