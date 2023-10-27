import SwiftUI

struct DetailedSheetView: View {
    
    var restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text(restaurant.Name)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top)
                
                HStack {
                    DistinctionView(distinction: restaurant.Distinction, bibendum: restaurant.Bibendum, sustainable: restaurant.Sustainable)
                        .font(.title2)
                    
                    Text(restaurant.RestaurantType)
                        .font(.title2)
                }
            }
            
           
            
            AsyncImage(url: URL(string: restaurant.IMG)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.icloud")
                } else {
                    VStack {
                        Color(UIColor.systemGray4)
                        ProgressView()
                    }
                }

            }
            .cornerRadius(20)
            .padding()
        }
        .padding(.top)

    }
}

#Preview {
    DetailedSheetView(restaurant: loadCSVData().first!)
}
