import SwiftUI
import MapKit

struct RestaurantRowView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                Text(restaurant.Name)
                    .font(.headline)
                
                HStack {
                    
                    // Subview that shows the correct distinction
                    DistinctionView(distinction: restaurant.Distinction, bibendum: restaurant.Bibendum, sustainable: restaurant.Sustainable)
                    
                    Text(restaurant.City)
                        .font(.subheadline)
                    
                    Text(restaurant.RestaurantType)
                        .font(.subheadline)
                }
            }
            
            Spacer()
            
            // Phone Button
            Button {
                let formattedphone = FormatPhoneNumber(phone: restaurant.Phone)
                guard let url = URL(string: formattedphone) else { return }
                
                // open phone app and call the number
                UIApplication.shared.open(url)
                
            } label: {
                // gray out and disable phone button if the restaurant does not have a number
                Image(systemName: FormatPhoneNumber(phone: restaurant.Phone) == "0" ? "phone" : "phone.fill")
                    .foregroundStyle(FormatPhoneNumber(phone: restaurant.Phone) == "0" ? .gray : .green)
            }
            .disabled(FormatPhoneNumber(phone: restaurant.Phone) == "0")

            .buttonStyle(.bordered)
            .clipShape(Circle())
            
            // Map Button
            Button {
                
                // function to open Apple Maps with input address
                openMap(Address: restaurant.Address)
                
            } label: {
                Image(systemName: "map.fill")
                    .foregroundStyle(.cyan)
            }
            .buttonStyle(.bordered)
            .clipShape(Circle())
            
        }
    }
}

// Open Apple Maps with URL
func openMap(Address: String) {
    UIApplication.shared.open(NSURL(string: "https://maps.apple.com/?address=\(Address)")! as URL)
}

// *Deprecated* Open Apple Maps with geocoder
// Will only show the address but not the location information in Maps
// Using URL is a better solution
func openMapWithAddress(Address: String) {
    
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(Address) { placemarks, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let placemark = placemarks?.first else {
            return
        }
        
        guard let lat = placemark.location?.coordinate.latitude else{return}
        
        guard let lon = placemark.location?.coordinate.longitude else{return}
        
        let coords = CLLocationCoordinate2DMake(lat, lon)
        
        let place = MKPlacemark(coordinate: coords)
        
        let mapItem = MKMapItem(placemark: place)
        mapItem.name = placemark.name
        mapItem.openInMaps(launchOptions: nil)
    }
    
}

// Clean up +886 and whitespaces in phone numbers
func FormatPhoneNumber(phone: String) -> String {
    
    var formattedNumber: String
    let tel = "tel://"
    
    if phone.first != "+" {
        return "0"
    } else {
        formattedNumber = phone.replacingOccurrences(of: "+886", with: "0")
        formattedNumber = formattedNumber.trimmingCharacters(in: .whitespaces)
        formattedNumber = tel + formattedNumber
        
        return formattedNumber
    }
}

#Preview {
    List(0 ..< 10) { item in
        RestaurantRowView(restaurant: loadCSVData()[item])
    }
}
