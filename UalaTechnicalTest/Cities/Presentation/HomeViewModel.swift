//
//  HomeViewModel.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import Combine

class HomeViewModel: ObservableObject {
    @Published var showFavoritesOnly = false {
        didSet {
            Task {
                await filterCities()
            }
        }
    }
    @Published var searchText = "" {
        didSet {
            Task {
                await filterCities()
            }
        }
    }
    @Published var loading = false
    @Published var selectedCity: CityViewModel?
    
    @Published var filteredCities: [CityViewModel] = []
    private var rawCities: [City] = []
    private var cities: [CityViewModel] = [] {
        didSet {
            Task {
                await filterCities()
            }
        }
    }
    private let listCitiesUseCase: any ListCitiesUseCase
    private let markCityAsFavoriteUseCase: any MarkCityAsFavoriteUseCase
    private let unmarkCityAsFavoriteUseCase: any UnmarkCityAsFavoriteUseCase
    private let filterCitiesUseCase: any FilterCitiesUseCase
    
    init(listCitiesUseCase: any ListCitiesUseCase,
         markCityAsFavoriteUseCase: any MarkCityAsFavoriteUseCase,
         unmarkCityAsFavoriteUseCase: any UnmarkCityAsFavoriteUseCase,
         filterCitiesUseCase: any FilterCitiesUseCase
    ) {
        self.listCitiesUseCase = listCitiesUseCase
        self.markCityAsFavoriteUseCase = markCityAsFavoriteUseCase
        self.unmarkCityAsFavoriteUseCase = unmarkCityAsFavoriteUseCase
        self.filterCitiesUseCase = filterCitiesUseCase
    }
    
    func filterCities() async {
        do {
            filterCitiesUseCase.set(cities: cities)
            filterCitiesUseCase.set(favoritesOnly: showFavoritesOnly)
            filterCitiesUseCase.set(searchText: searchText)
            try await filterCitiesUseCase.execute()
            try await setFilteredCities()
        } catch {
            print("Unexpected error")
        }
    }
    
    @MainActor
    func setFilteredCities() async throws {
        filteredCities = try filterCitiesUseCase.getResult()
    }
    
    func processOnAppear() {
        guard !loading else { return }
        
        Task {
            await startLoading()
            await downloadData()
            await presentCities()
            await stopLoading()
        }
    }
    
    @MainActor
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
    
    @MainActor
    private func presentCities() {
        cities = rawCities.map({
            CityViewModelFactory().create(city: $0)
        })
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
