//
//  ContentView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import SwiftUI

class ContentFactory {
    func create() -> ContentView {
        let city1 = City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359))
        let city2 = City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
        
        let viewModel = ContentViewModel()
        viewModel.cities = [city1, city2]
        return .init(viewModel: viewModel)
    }
}

class ContentViewModel: Observable {
    @Published var cities: [City] = []
    @Published var selectedCity: City?
    @Published var loading = false
}

struct ContentView: View {
    @State var viewModel: ContentViewModel
    
    var body: some View {
        NavigationStack {
            CityListFactory().create(cities: $viewModel.cities, selectedCity: $viewModel.selectedCity)
                .overlay {
                    if viewModel.loading {
                        ProgressView()
                    }
                }
        }
    }
}

#Preview() {
    let viewModel: ContentViewModel = {
        let city1 = City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359))
        let city2 = City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
        
        let result = ContentViewModel()
        result.cities = [city1, city2]
        return result
    }()
    ContentView(viewModel: viewModel)
}

#Preview() {
    let viewModel: ContentViewModel = {
        let result = ContentViewModel()
        result.loading = true
        return result
    }()
    ContentView(viewModel: viewModel)
}
