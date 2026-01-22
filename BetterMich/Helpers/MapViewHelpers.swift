import CoreLocation
import MapKit
import UIKit

func FormatAddress(address: String) -> String {

    var formattedAddress: String = address

    formattedAddress = formattedAddress.replacingOccurrences(
        of: "Taipei",
        with: "台北市"
    )
    formattedAddress = formattedAddress.replacingOccurrences(
        of: "Taichung",
        with: "台中市"
    )
    formattedAddress = formattedAddress.replacingOccurrences(
        of: "Tainan",
        with: "台南市"
    )
    formattedAddress = formattedAddress.replacingOccurrences(
        of: "Kaohsiung",
        with: "高雄市"
    )

    return formattedAddress
}

func getCoordinate(address: String) -> CLLocationCoordinate2D {
    let geocoder = CLGeocoder()
    var coord = CLLocationCoordinate2D()

    geocoder.geocodeAddressString(
        address,
        completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let placemarks = placemarks,
                let location = placemarks[0].location
            else {
                return
            }
            coord = location.coordinate
        }
    )

    return coord
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
