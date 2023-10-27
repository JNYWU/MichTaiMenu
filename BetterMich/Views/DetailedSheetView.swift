import SwiftUI

struct DetailedSheetView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(spacing: 8) {
                    Text(restaurant.Name)
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    HStack {
                        DistinctionView(distinction: restaurant.Distinction, bibendum: restaurant.Bibendum, sustainable: restaurant.Sustainable)
                            .font(.title3)
                        
                        Text(restaurant.RestaurantType)
                            .font(.title3)
                    }
                }
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity)

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
                .frame(width: 120, height: 120, alignment: .leading)
                .cornerRadius(20)
                .padding(.trailing)

            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("餐廳簡介")
                    .font(.headline)
                Text(restaurant.Description)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("電話")
                            .font(.headline)
                        Text(restaurant.Phone)
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("地址")
                            .font(.headline)
                        Text(restaurant.Address)
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .padding(.horizontal)
            
            
            
        }
        .padding(.top)
        
    }
}

#Preview {
    DetailedSheetView(restaurant: loadCSVData().first!)
}
