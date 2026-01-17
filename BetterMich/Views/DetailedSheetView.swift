import SwiftUI
import MapKit

struct DetailedSheetView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            // HStack for photo and title VStack
            HStack {
                
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
                
                // Vstack for name, type, distinction
                VStack(alignment: .leading, spacing: 8) {
                    Text(restaurant.Name)
                        .font(.largeTitle.bold())
                    
                    Text(restaurant.RestaurantType)
                        .font(.title3)
                        .foregroundStyle(Color(.secondaryLabel))
                                        
                    DistinctionView(distinction: restaurant.Distinction, bibendum: restaurant.Bibendum, sustainable: restaurant.Sustainable)
                        .font(.title2)
                    
                    
                }
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            // VStack for description, phone, address
            VStack(alignment: .leading, spacing: 5) {
                Label("餐廳簡介", systemImage: "doc.append")
                    .font(.headline)
                Text(restaurant.Description)
                
                Divider()
                    .padding(.bottom)
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("電話", systemImage: "phone")
                            .font(.headline)
                        
                        if restaurant.Phone.first == "+" {
                            Text(restaurant.Phone)
                            
                            // call button
                            Button {
                                let formattedphone = FormatPhoneNumber(phone: restaurant.Phone)
                                guard let url = URL(string: formattedphone) else { return }
                                
                                // open phone app and call the number
                                UIApplication.shared.open(url)
                                
                            } label: {
                                HStack {
                                    Image(systemName: "phone.arrow.up.right.fill")
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
                        Label("地址", systemImage: "map")
                            .font(.headline)
                        Text(FormatAddress(address: restaurant.Address))
                    }
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .padding()
            
             Divider()
                .padding(.horizontal)
            
            MapView(restaurant: restaurant)
      
        }
        .padding(.top)
        
    }
}

func FormatAddress(address: String) -> String {
    
    var formattedAddress: String = address
    
    formattedAddress = formattedAddress.replacingOccurrences(of: "Taipei", with: "台北市")
    formattedAddress = formattedAddress.replacingOccurrences(of: "Taichung", with: "台中市")
    formattedAddress = formattedAddress.replacingOccurrences(of: "Tainan", with: "台南市")
    formattedAddress = formattedAddress.replacingOccurrences(of: "Kaohsiung", with: "高雄市")

        
    return formattedAddress
}

func getCoordinate (address: String) -> CLLocationCoordinate2D {
    let geocoder = CLGeocoder()
    var coord = CLLocationCoordinate2D()
    
    geocoder.geocodeAddressString(address, completionHandler: { placemarks, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let placemarks = placemarks,
              let location = placemarks[0].location else {
            return
        }
        coord = location.coordinate
    })
    
    return coord
}

#Preview {
    DetailedSheetView(restaurant: Restaurant(
        id: 1,
        name: "示範餐廳",
        distinction: 1,
        sustainable: false,
        bibendum: false,
        city: "台北",
        restaurantType: "現代料理",
        phone: "+886 2 1234 5678",
        img: "https://example.com/image.jpg",
        address: "台北市中正區",
        description: "示範用餐廳描述"
    ))
}
