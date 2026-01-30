import SwiftUI
import MapKit

struct MapView: View {
    
    var restaurant: Restaurant
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.04841, longitude: 121.53301),
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
    )
    @State private var fallbackCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 25.04841, longitude: 121.53301)
    @State private var mapItem: MKMapItem?
    @State private var shouldShowPin = false
    
    var body: some View {
        Map(position: $position, interactionModes: [.zoom, .pan]) {
            if shouldShowPin {
                if let mapItem {
                    Marker(item: mapItem)
                } else {
                    Marker(restaurant.Name, systemImage: "fork.knife", coordinate: fallbackCoordinate)
                        .tint(.orange)
                }
            }
        }
        .task {
            await resolveLocation()
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                if let mapItem {
                    mapItem.openInMaps()
                } else {
                    openMap(Address: restaurant.Address)
                }
            }
        )
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
    
    @MainActor
    private func resolveLocation() async {
        let geocoder = CLGeocoder()
        let address = restaurant.Address
        var addressCoordinate = fallbackCoordinate

        do {
            if let location = try await geocoder
                .geocodeAddressString(address)
                .first?
                .location
            {
                addressCoordinate = location.coordinate
                fallbackCoordinate = location.coordinate
                withAnimation(.easeInOut(duration: 0.3)) {
                    position = .region(
                        MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                        )
                    )
                }
            }
        } catch {
            return
        }

        if let foundItem = await searchBestMapItem(
            name: restaurant.Name,
            address: address,
            near: addressCoordinate
        ) {
            mapItem = foundItem
            withAnimation(.easeInOut(duration: 0.35)) {
                position = .region(
                    MKCoordinateRegion(
                        center: foundItem.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                    )
                )
            }
        }
        withAnimation(.easeInOut(duration: 0.25)) {
            shouldShowPin = true
        }
    }
}

private func searchBestMapItem(
    name: String,
    address: String,
    near coordinate: CLLocationCoordinate2D
) async -> MKMapItem? {
    let targetName = normalizeText(name)
    if targetName.isEmpty { return nil }

    let addressLocation = CLLocation(
        latitude: coordinate.latitude,
        longitude: coordinate.longitude
    )

    if let addressItems = await searchMapItems(
        query: address,
        near: coordinate,
        resultTypes: [.address, .pointOfInterest]
    ),
    let nameMatched = matchByName(
        items: addressItems,
        targetName: targetName
    ) {
        return closestItem(
            from: nameMatched,
            addressLocation: addressLocation
        )
    }

    if let nameItems = await searchMapItems(
        query: "\(name) \(address)",
        near: coordinate,
        resultTypes: [.pointOfInterest]
    ),
    let nameMatched = matchByName(
        items: nameItems,
        targetName: targetName
    ) {
        return closestItem(
            from: nameMatched,
            addressLocation: addressLocation
        )
    }

    return nil
}

private func searchMapItems(
    query: String,
    near coordinate: CLLocationCoordinate2D,
    resultTypes: MKLocalSearch.ResultType
) async -> [MKMapItem]? {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.region = MKCoordinateRegion(
        center: coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    request.resultTypes = resultTypes

    let search = MKLocalSearch(request: request)
    guard let response = try? await search.start() else { return nil }
    return response.mapItems
}

private func matchByName(
    items: [MKMapItem],
    targetName: String
) -> [MKMapItem]? {
    let matched = items.filter {
        let candidate = normalizeText(
            $0.name
                ?? $0.placemark.name
                ?? $0.placemark.title
                ?? ""
        )
        return !candidate.isEmpty
            && (candidate.contains(targetName)
                || targetName.contains(candidate))
    }
    return matched.isEmpty ? nil : matched
}

private func closestItem(
    from items: [MKMapItem],
    addressLocation: CLLocation
) -> MKMapItem? {
    let sortedByDistance = items.sorted {
        CLLocation(
            latitude: $0.placemark.coordinate.latitude,
            longitude: $0.placemark.coordinate.longitude
        ).distance(from: addressLocation)
        < CLLocation(
            latitude: $1.placemark.coordinate.latitude,
            longitude: $1.placemark.coordinate.longitude
        ).distance(from: addressLocation)
    }
    if let nearest = sortedByDistance.first {
        let nearestDistance = CLLocation(
            latitude: nearest.placemark.coordinate.latitude,
            longitude: nearest.placemark.coordinate.longitude
        ).distance(from: addressLocation)
        if nearestDistance <= 1000 {
            return nearest
        }
    }
    return sortedByDistance.first
}

private func normalizeText(_ text: String) -> String {
    let folded = text.folding(
        options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive],
        locale: .current
    )
    let scalars = folded.unicodeScalars.filter {
        CharacterSet.alphanumerics.contains($0)
    }
    return String(String.UnicodeScalarView(scalars))
}

#Preview {
    MapView(restaurant: Restaurant(
        id: "sample-1",
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

