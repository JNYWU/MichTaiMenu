import MapKit
import SwiftUI

struct RestaurantRowView: View {

    var restaurant: Restaurant
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {

        HStack {

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    //MARK: 餐廳
                    Text(restaurant.Name)
                        .font(.headline)
                        .foregroundStyle(.buttonRowText)
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

                //MARK: 評鑑等級、城市、類型
                HStack {

                    // Subview that shows the correct distinction
                    DistinctionView(
                        distinction: restaurant.Distinction,
                        bibendum: restaurant.Bibendum,
                        sustainable: restaurant.Sustainable
                    )

                    Text(restaurant.City)
                        .font(.subheadline)
                        .foregroundStyle(.buttonRowText)

                    Text(restaurant.RestaurantType)
                        .font(.subheadline)
                        .foregroundStyle(.buttonRowText)
                }
            }

            Spacer()

            HStack(spacing: 15) {
                //MARK: 曾造訪
                Button {
                } label: {
                    Image(systemName: "figure.stand")
                        .frame(width: 35, height: 35)
                        
                }
                .foregroundStyle(.cyan)
                .buttonStyle(.bordered)
                .frame(width: 35, height: 35)
                .tint(.cyan)
                .clipShape(Circle())
                .glassChip()

                //MARK: 喜愛
                Button {
                } label: {
                    Image(systemName: "heart.fill")
                        .frame(width: 35, height: 35)
                }
                .foregroundStyle(.red)
                .buttonStyle(.bordered)
                .frame(width: 35, height: 35)
                .tint(.red)
                .clipShape(Circle())
                .glassChip()
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 5, y: 10)
        .padding(.horizontal)
        .padding(.bottom, 4)

    }
}

#Preview {
    NavigationStack {
        ScrollView {

            let Restaurants = [
                Restaurant(
                    id: 1,
                    name: "示範餐廳",
                    distinction: 1,
                    sustainable: false,
                    bibendum: false,
                    isNew: true,
                    city: "台北",
                    restaurantType: "現代料理",
                    phone: "+886 2 1234 5678",
                    img: "https://example.com/image.jpg",
                    address: "台北市中正區",
                    description: "示範用餐廳描述"
                )
            ]

            ForEach(Restaurants) { restaurant in
                RestaurantRowView(restaurant: restaurant)
            }
        }
        .navigationTitle("米台目")
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
