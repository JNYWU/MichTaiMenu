import SwiftUI

struct DetailedSheetView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            HStack {
                
                AsyncImage(url: URL(string: restaurant.IMG)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.icloud")
                    } else {
                        ZStack {
                            Color(UIColor.systemGray4)
                            ProgressView()
                        }
                    }
                    
                }
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.Name)
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text(restaurant.RestaurantType)
                        .font(.title3)
                                        
                    DistinctionView(distinction: restaurant.Distinction, bibendum: restaurant.Bibendum, sustainable: restaurant.Sustainable)
                        .font(.title2)
                    
                    
                }
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("餐廳簡介")
                    .font(.headline)
                Text(restaurant.Description)
                
                Divider()
                    .padding(.bottom)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("電話")
                            .font(.headline)
                        
                        if restaurant.Phone.first == "+" {
                            Text(restaurant.Phone)
                            
                            Button {
                                let formattedphone = FormatPhoneNumber(phone: restaurant.Phone)
                                guard let url = URL(string: formattedphone) else { return }
                                
                                // open phone app and call the number
                                UIApplication.shared.open(url)
                                
                            } label: {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("撥號")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .foregroundStyle(.green)
                            .buttonStyle(.bordered)
                            .padding(.horizontal, 5)
                        } else {
                            Text("無號碼")
                        }
                        
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("地址")
                            .font(.headline)
                        Text(restaurant.Address)
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .padding()
      
        }
        .padding(.top)
        
    }
}

#Preview {
    DetailedSheetView(restaurant: loadCSVData().first!)
}
