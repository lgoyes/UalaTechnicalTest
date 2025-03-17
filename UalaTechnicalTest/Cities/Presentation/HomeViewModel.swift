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
    private let filterCitiesUseCase: any FilterCitiesUseCase
    private let toggleFavoriteUseCase: any ToggleFavoriteUseCase
    
    init(listCitiesUseCase: any ListCitiesUseCase,
         filterCitiesUseCase: any FilterCitiesUseCase,
         toggleFavoriteUseCase: any ToggleFavoriteUseCase
    ) {
        self.listCitiesUseCase = listCitiesUseCase
        self.filterCitiesUseCase = filterCitiesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
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
            try await downloadData()
            await presentCities()
            await stopLoading()
        }
    }
    
    @MainActor
    private func startLoading() {
        loading = true
    }
    
    private func downloadData() async throws {
        await performRequest()
        try await extractResults(from: listCitiesUseCase)
    }
    
    private func performRequest() async {
        try! await listCitiesUseCase.execute()
    }
    
    @MainActor
    private func extractResults<ResultSource: Resultable>(from source: ResultSource) throws where ResultSource.Output == [City]  {
        rawCities = try source.getResult()
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
    
    func favoriteTapped(city: CityViewModel) {
        Task {
            toggleFavoriteUseCase.set(favoriteCandidateId: city.id)
            toggleFavoriteUseCase.set(rawCities: rawCities)
            try await toggleFavoriteUseCase.execute()
            try await extractResults(from: toggleFavoriteUseCase)
            await presentCities()
        }
    }
}
