import MapKit
import SwiftData
import SwiftUI

struct RestaurantRowView: View {

    var restaurant: Restaurant
    @Environment(\.colorScheme) private var colorScheme
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

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

            if isPreview {
                PreviewRowStateButtons()
            } else {
                LiveRowStateButtons(restaurantId: restaurant.id)
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

private struct LiveRowStateButtons: View {
    let restaurantId: String
    @Environment(\.modelContext) private var modelContext
    @Query private var states: [RestaurantState]

    init(restaurantId: String) {
        self.restaurantId = restaurantId
        _states = Query(
            filter: #Predicate<RestaurantState> {
                $0.restaurantKey == restaurantId
            }
        )
    }

    var body: some View {
        HStack(spacing: 15) {
            Button {
                toggleVisited()
            } label: {
                Image(
                    systemName: isVisited
                        ? "checkmark.seal.fill"
                        : "checkmark.seal"
                )
                .frame(width: 35, height: 35)
            }
            .foregroundStyle(isVisited ? .teal : .secondary)
            .buttonStyle(.bordered)
            .frame(width: 35, height: 35)
            .tint(isVisited ? .teal : .gray)
            .clipShape(Circle())
            .glassChip()

            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .frame(width: 35, height: 35)
            }
            .foregroundStyle(isFavorite ? .red : .secondary)
            .buttonStyle(.bordered)
            .frame(width: 35, height: 35)
            .tint(isFavorite ? .red : .gray)
            .clipShape(Circle())
            .glassChip()
        }
    }

    private var isVisited: Bool {
        states.first?.isVisited ?? false
    }

    private var isFavorite: Bool {
        states.first?.isFavorite ?? false
    }

    private func toggleVisited() {
        if let state = states.first {
            state.isVisited.toggle()
            cleanupIfNeeded(state)
        } else {
            modelContext.insert(
                RestaurantState(
                    restaurantKey: restaurantId,
                    isVisited: true
                )
            )
        }
    }

    private func toggleFavorite() {
        if let state = states.first {
            state.isFavorite.toggle()
            cleanupIfNeeded(state)
        } else {
            modelContext.insert(
                RestaurantState(
                    restaurantKey: restaurantId,
                    isFavorite: true
                )
            )
        }
    }

    private func cleanupIfNeeded(_ state: RestaurantState) {
        if !state.isVisited && !state.isFavorite {
            modelContext.delete(state)
        }
    }
}

private struct PreviewRowStateButtons: View {
    @State private var isVisited = false
    @State private var isFavorite = false

    var body: some View {
        HStack(spacing: 15) {
            Button {
                isVisited.toggle()
            } label: {
                Image(
                    systemName: isVisited
                        ? "checkmark.seal.fill"
                        : "checkmark.seal"
                )
                .frame(width: 35, height: 35)
            }
            .foregroundStyle(isVisited ? .teal : .secondary)
            .buttonStyle(.bordered)
            .frame(width: 35, height: 35)
            .tint(isVisited ? .teal : .gray)
            .clipShape(Circle())
            .glassChip()

            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .frame(width: 35, height: 35)
            }
            .foregroundStyle(isFavorite ? .red : .secondary)
            .buttonStyle(.bordered)
            .frame(width: 35, height: 35)
            .tint(isFavorite ? .red : .gray)
            .clipShape(Circle())
            .glassChip()
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {

            let Restaurants = [
                Restaurant(
                    id: "sample-1",
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
    .modelContainer(for: RestaurantState.self, inMemory: true)
}
