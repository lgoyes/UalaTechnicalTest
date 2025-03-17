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
    
    private var rawCities: [City] = [] {
        didSet {
            cities = rawCities.map({
                CityViewModelFactory().create(city: $0)
            })
        }
    }
    
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
    
    func getSelectedCityMapModel() -> CityMapViewModel? {
        guard let selectedCityModel = selectedCity, let selectedCity = rawCities.first(where: { $0.id == selectedCityModel.id }) else {
            return nil
        }
        return CityMapViewModel(latitude: selectedCity.coordinates.latitude, longitude: selectedCity.coordinates.longitude, name: selectedCityModel.title)
    }
    
    func favoriteTapped(city: CityViewModel) {
        print("\(city.favorite ? "Unmarking" : "Marking") \(city.title) as favorite...")
        if let index = rawCities.firstIndex(where: { $0.id == city.id } ) {
            let cityUnderInspection = rawCities[index]
            if cityUnderInspection.favorite {
                unmarkCityAsFavoriteUseCase.set(favoriteToRemove: cityUnderInspection)
                Task {
                    do {
                        try await unmarkCityAsFavoriteUseCase.execute()
                        cityUnderInspection.favorite = false
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            } else {
                markCityAsFavoriteUseCase.set(newFavorite: cityUnderInspection)
                Task {
                    do {
                        try await markCityAsFavoriteUseCase.execute()
                        cityUnderInspection.favorite = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        if let index = cities.firstIndex(where: { $0.id == city.id } ) {
            cities[index].favorite.toggle()
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
                            viewModel.favoriteTapped(city: city)
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

