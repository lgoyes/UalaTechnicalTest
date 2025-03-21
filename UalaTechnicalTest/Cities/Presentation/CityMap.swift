//
//  CityMap.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI
import MapKit

struct CityMapViewModel: Equatable {
    let latitude: Double
    let longitude: Double
    let name: String
}

struct CityMapViewModelFactory {
    func create(from city: CityViewModel) -> CityMapViewModel? {
        let parts = city.subtitle.split(separator: ", ")
        guard parts.count == 2,
           let latPart = parts.first?.split(separator: ":").last,
           let lonPart = parts.last?.split(separator: ":").last,
           let latitude = Double(latPart.trimmingCharacters(in: .whitespaces)),
           let longitude = Double(lonPart.trimmingCharacters(in: .whitespaces)) else {
            return nil
        }
        
        return CityMapViewModel(latitude: latitude, longitude: longitude, name: city.title)
    }
}

struct CityMapView: View {
    private enum Constant {
        static let span = 0.2
    }
    @State private var cameraPosition: MapCameraPosition = .automatic
    let viewModel: CityMapViewModel
    
    private func updateCameraPosition() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude),
            span: MKCoordinateSpan(latitudeDelta: Constant.span, longitudeDelta: Constant.span)
        )
        cameraPosition = MapCameraPosition.region(region)
    }
    
    var body: some View {
        Map(position: $cameraPosition)
            .accessibilityIdentifier("city-map")
            .onChange(of: viewModel, { oldValue, newValue in
                updateCameraPosition()
            })
            .onAppear {
                updateCameraPosition()
            }
            .navigationTitle(viewModel.name)
    }
}

class CityMapFactory {
    func create(with city: City) -> CityMapView {
        let viewModel = CityMapViewModel(latitude: city.coordinates.latitude, longitude: city.coordinates.longitude, name: city.name)
        return CityMapView(viewModel: viewModel)
    }
}

#Preview("Map centered on Medellín") {
    let medellin = (lat: 6.25184, lon: -75.56359)
    let viewModel = CityMapViewModel(latitude: medellin.lat, longitude: medellin.lon, name: "Medellin")
    NavigationStack {
        CityMapView(viewModel: viewModel)
    }
}
