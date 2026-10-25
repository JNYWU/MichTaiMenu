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

// Open Apple Maps with URL
func openMap(Address: String) {
    UIApplication.shared.open(NSURL(string: "https://maps.apple.com/?address=\(Address)")! as URL)
}
