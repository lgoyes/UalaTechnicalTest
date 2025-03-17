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
        let markCityAsFavoriteUseCase = MarkCityAsFavoriteUseCaseFactory(context: context).create()
        let unmarkCityAsFavoriteUseCase = UnmarkCityAsFavoriteUseCaseFactory(context: context).create()
        let viewModel = HomeViewModel(listCitiesUseCase: listUseCase, markCityAsFavoriteUseCase: markCityAsFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkCityAsFavoriteUseCase)
        return .init(viewModel: viewModel)
    }
}

class HomeViewModel: ObservableObject {
    @Published var showFavoritesOnly = false {
        didSet {
            filterCities()
        }
    }
    @Published var searchText = "" {
        didSet {
            filterCities()
        }
    }
    @Published var loading = false
    @Published var filteredCities: [CityViewModel] = []
    @Published var selectedCity: CityViewModel?
    
    private var cities: [CityViewModel] = [] {
        didSet {
            filterCities()
        }
    }
    private let listCitiesUseCase: any ListCitiesUseCase
    private let markCityAsFavoriteUseCase: any MarkCityAsFavoriteUseCase
    private let unmarkCityAsFavoriteUseCase: any UnmarkCityAsFavoriteUseCase
    private var rawCities: [City] = []
    
    func filterCities() {
        var results = cities
        
        if showFavoritesOnly {
            results = results.filter { $0.favorite }
        }
        
        if !searchText.isEmpty {
            results = results.filter { $0.title.lowercased().hasPrefix(searchText.lowercased())
            }
        }
        
        filteredCities = results
    }
    
    init(listCitiesUseCase: any ListCitiesUseCase, markCityAsFavoriteUseCase: any MarkCityAsFavoriteUseCase, unmarkCityAsFavoriteUseCase: any UnmarkCityAsFavoriteUseCase) {
        self.listCitiesUseCase = listCitiesUseCase
        self.markCityAsFavoriteUseCase = markCityAsFavoriteUseCase
        self.unmarkCityAsFavoriteUseCase = unmarkCityAsFavoriteUseCase
    }
    
    func processOnAppear() {
        guard !loading else { return }
        startLoading()
        Task {
            await downloadData()
            await presentCities()
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
    
    @MainActor
    private func presentCities() {
        cities = rawCities.map({
            CityViewModelFactory().create(city: $0)
        })
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
    
    func getSelectedCityMapModel() -> CityMapViewModel? {
        guard let selectedCityModel = selectedCity, let selectedCity = rawCities.first(where: { $0.id == selectedCityModel.id }) else {
            return nil
        }
        return CityMapViewModel(latitude: selectedCity.coordinates.latitude, longitude: selectedCity.coordinates.longitude, name: selectedCityModel.title)
    }
    
    @MainActor
    private func updateCityViewModelFavorite(with city: City) {
        let newFavoriteValue = !city.favorite
        if let index = cities.firstIndex(where: { $0.id == city.id } ) {
            rawCities[index].favorite = newFavoriteValue
            cities[index].favorite = newFavoriteValue
        }
    }
    
    func favoriteTapped(city: CityViewModel) async {
        guard let updatedCityIndex = rawCities.firstIndex(where: { $0.id == city.id } ) else {
            return
        }
        let updatedCity = rawCities[updatedCityIndex]
        let useCase: any Command
        if updatedCity.favorite {
            useCase = unmarkCityAsFavoriteUseCase
            unmarkCityAsFavoriteUseCase.set(favoriteToRemove: updatedCity)
        } else {
            useCase = markCityAsFavoriteUseCase
            markCityAsFavoriteUseCase.set(newFavorite: updatedCity)
        }
        do {
            try await useCase.execute()
            await updateCityViewModelFavorite(with: updatedCity)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                HomeMadeNavigationSplitView(selected: $viewModel.selectedCity) { shouldNavigate in
                    CityListFactory()
                        .create(cities: viewModel.filteredCities, selectedCity: $viewModel.selectedCity, shouldNavigate: shouldNavigate, onFavoriteTapped: { city in
                            Task {
                                await viewModel.favoriteTapped(city: city)
                            }
                        })
                        .searchable(text: $viewModel.searchText, prompt: "Search entries")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: { viewModel.showFavoritesOnly.toggle() }) {
                                    Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star") // Toggle icon
                                        .foregroundColor(viewModel.showFavoritesOnly ? .yellow : .gray)
                                }
                            }
                        }
                } detail: { selectedCity in
                    CityMapView(viewModel: viewModel.getSelectedCityMapModel()!)
                } defaultDetail: {
                    Text("No city selected")
                }
            }
        }
        .onAppear() {
            viewModel.processOnAppear()
        }
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
class FakeMarkFavoriteUseCase: MarkCityAsFavoriteUseCase {
    func set(newFavorite: City) {}
    func execute() async throws(MarkCityAsFavoriteUseCaseError) {}
}
class FakeUnmarkFavoriteUseCase: UnmarkCityAsFavoriteUseCase {
    func set(favoriteToRemove: City) {}
    func execute() async throws(UnmarkCityAsFavoriteUseCaseError) {}
}
#endif


#Preview("Portrait", traits: .portrait) {
    @Previewable @State var viewModel: HomeViewModel = {
        let downloadEntriesUseCase = FakeListCitiesUseCase()
        downloadEntriesUseCase.result = [
            City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359)),
            City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
        ]
        let markFavoriteUseCase = FakeMarkFavoriteUseCase()
        let unmarkFavoriteUseCase = FakeUnmarkFavoriteUseCase()
        
        let result = HomeViewModel(listCitiesUseCase: downloadEntriesUseCase, markCityAsFavoriteUseCase: markFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkFavoriteUseCase)
        return result
    }()
    HomeView(viewModel: viewModel)
}

#Preview("Landscape right", traits: .landscapeRight) {
    let viewModel: HomeViewModel = {
        let downloadEntriesUseCase = FakeListCitiesUseCase()
        let markFavoriteUseCase = FakeMarkFavoriteUseCase()
        let unmarkFavoriteUseCase = FakeUnmarkFavoriteUseCase()
        
        let result = HomeViewModel(listCitiesUseCase: downloadEntriesUseCase, markCityAsFavoriteUseCase: markFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkFavoriteUseCase)
        result.loading = true
        return result
    }()
    HomeView(viewModel: viewModel)
}

