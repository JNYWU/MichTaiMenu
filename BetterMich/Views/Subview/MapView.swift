import SwiftUI
import MapKit

struct MapView: View {
    
    var restaurant: Restaurant
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.04841, longitude: 121.53301), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    @State private var annotatedItem: AnnotatedItem = AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: 25.04841, longitude: 121.53301))
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.zoom, .pan], annotationItems: [annotatedItem]) { item in
            MapMarker(coordinate: item.coordinate)
        }
        .task {
            convertAddress(location: restaurant.Address)
        }
        .onTapGesture {
            openMap(Address: restaurant.Address)
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
    
    private func convertAddress(location: String) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks,
                  let location = placemarks[0].location else {
                return
            }
            
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            
            self.annotatedItem = AnnotatedItem(coordinate: location.coordinate)
        })
    }
}

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView(restaurant: Restaurant(
        id: 1,
        name: "示範餐廳",
        distinction: 1,
        sustainable: false,
        bibendum: false,
        isNew: false,
        city: "台北",
        restaurantType: "現代料理",
        phone: "+886 2 1234 5678",
        img: "https://example.com/image.jpg",
        address: "台北市中正區",
        description: "示範用餐廳描述"
    ))
}

