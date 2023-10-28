import SwiftUI
import MapKit

struct MapView: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        Text(restaurant.Name)
    }
}

#Preview {
    MapView(restaurant: loadCSVData().first!)
}
