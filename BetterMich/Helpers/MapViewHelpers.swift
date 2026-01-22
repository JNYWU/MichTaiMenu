import CoreLocation

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

