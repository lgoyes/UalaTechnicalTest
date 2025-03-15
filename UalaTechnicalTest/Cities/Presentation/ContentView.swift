//
//  ContentView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import SwiftUI
import SwiftData

class ContentFactory {
    func create(with context: ModelContext) -> ContentView {
        let listUseCase = ListCitiesUseCaseFactory(context: context).create()
        let viewModel = ContentViewModel(listCitiesUseCase: listUseCase)
        return .init(viewModel: viewModel)
    }
}

class ContentViewModel: Observable {
    @Published var cities: [CityViewModel] = []
    @Published var selectedCity: CityViewModel?
    @Published var loading = false
    
    private let listCitiesUseCase: any ListCitiesUseCase
    init(listCitiesUseCase: any ListCitiesUseCase) {
        self.listCitiesUseCase = listCitiesUseCase
    }
    
    private var rawCities: [City] = [] {
        didSet {
            cities = rawCities.map({
                CityViewModelFactory().create(city: $0)
            })
        }
    }
    
    private var rawSelectedCity: City? {
        didSet {
            if let rawSelectedCity {
                selectedCity = CityViewModelFactory().create(city: rawSelectedCity)
            }
        }
    }
    
    func setRawCities(_ rawCities: [City]) {
        self.rawCities = rawCities
    }
    
    func downloadData() async {
        loading = true
        try! await listCitiesUseCase.execute()
        rawCities = try! listCitiesUseCase.getResult()
        loading = false
    }
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
        }.onAppear() {
            Task {
                await viewModel.downloadData()
            }
        }
    }
}

//#Preview() {
//    @Previewable @State var viewModel: ContentViewModel = {
//        let city1 = City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359))
//        let city2 = City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
//        
//        let result = ContentViewModel()
//        result.setRawCities([ city1, city2 ])
//        return result
//    }()
//    ContentView(viewModel: viewModel)
//}
//
//#Preview() {
//    let viewModel: ContentViewModel = {
//        let result = ContentViewModel()
//        result.loading = true
//        return result
//    }()
//    ContentView(viewModel: viewModel)
//}
