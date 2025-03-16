//
//  HomeView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 16/3/25.
//

import SwiftUI
import SwiftData

class HomeFactory {
    func create(with context: ModelContext) -> HomeView {
        let listUseCase = ListCitiesUseCaseFactory(context: context).create()
        let viewModel = HomeViewModel(listCitiesUseCase: listUseCase)
        return .init(viewModel: viewModel)
    }
}

class HomeViewModel: ObservableObject {
    @Published var loading = false
    @Published var cities: [CityViewModel] = []
    @Published var selectedCity: CityViewModel?
    
    private let listCitiesUseCase: any ListCitiesUseCase
    private var rawCities: [City] = [] {
        didSet {
            cities = rawCities.map({
                CityViewModelFactory().create(city: $0)
            })
        }
    }
    
    init(listCitiesUseCase: any ListCitiesUseCase) {
        self.listCitiesUseCase = listCitiesUseCase
    }
    
    func processOnAppear() {
        guard !loading else { return }
        startLoading()
        print("Downloading")
        Task {
            await downloadData()
            print("Downloaded")
            await stopLoading()
        }
    }
    
    private func startLoading() {
        loading = true
    }
    
    private func downloadData() async {
        await performRequest()
        await extractResults()
    }
    
    private func performRequest() async {
        try! await listCitiesUseCase.execute()
    }
    
    @MainActor private func extractResults() {
        rawCities = try! listCitiesUseCase.getResult()
    }
    
    @MainActor private func stopLoading() {
        loading = false
    }
    
    func select(city: CityViewModel) {
        if let previousSelectedCity = selectedCity, let previousSelectedIndex = cities.firstIndex(where: { $0.id == previousSelectedCity.id }) {
            print("Unselecting")
            cities[previousSelectedIndex].selected = false
        }
        if let currentSelectedIndex = cities.firstIndex(where: { $0.id == city.id }) {
            print("Selecting")
            cities[currentSelectedIndex].selected = true
            selectedCity = city
        }
    }
    
    func favoriteTapped(city: CityViewModel) {
        print("\(city.favorite ? "Unmarking" : "Marking") \(city.title) as favorite...")
        if let index = cities.firstIndex(where: { $0.id == city.id } ) {
            cities[index].favorite.toggle()
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        CityListFactory()
            .create(cities: viewModel.cities, selectedCity: viewModel.selectedCity, onFavoriteTapped: { city in
                viewModel.favoriteTapped(city: city)
            }) { selectedCity in
                viewModel.select(city: selectedCity)
            }
            .onAppear() {
                viewModel.processOnAppear()
            }
//            .overlay {
//                if viewModel.loading {
//                    ProgressView()
//                }
//            }
    }
}

#if DEBUG
class FakeListCitiesUseCase: ListCitiesUseCase {
    var result: [City] = []
    func execute() async throws(ListCitiesUseCaseError) {}
    
    func getResult() throws(ListCitiesUseCaseError) -> Array<City> {
        result
    }
}
#endif


#Preview() {
    @Previewable @State var viewModel: HomeViewModel = {
        let useCase = FakeListCitiesUseCase()
        useCase.result = [
            City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359)),
            City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
        ]
        let result = HomeViewModel(listCitiesUseCase: useCase)
        return result
    }()
    HomeView(viewModel: viewModel)
}

#Preview() {
    let viewModel: HomeViewModel = {
        let useCase = FakeListCitiesUseCase()
        let result = HomeViewModel(listCitiesUseCase: useCase)
        result.loading = true
        return result
    }()
    HomeView(viewModel: viewModel)
}

