//
//  FilterCitiesUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

enum FilterCitiesUseCaseError: Swift.Error {
    case inputNotSet
}

protocol FilterCitiesUseCase: UseCase where Output == [CityViewModel], ErrorType == FilterCitiesUseCaseError {
    func set(cities: [CityViewModel])
    func set(favoritesOnly: Bool)
    func set(searchText: String)
}

class DefaultFilterCitiesUseCase: FilterCitiesUseCase {
    private var cities: [CityViewModel]!
    private var searchText: String = ""
    private var favoritesOnly: Bool = false
    
    func set(cities: [CityViewModel]) {
        self.cities = cities
    }
    func set(searchText: String) {
        self.searchText = searchText.lowercased()
    }
    func set(favoritesOnly: Bool) {
        self.favoritesOnly = favoritesOnly
    }
    
    func execute() async throws(FilterCitiesUseCaseError) {
        guard cities != nil else {
            throw .inputNotSet
        }
        
        cities = cities.filter {
            if favoritesOnly && !$0.favorite {
                return false
            } else if !searchText.isEmpty {
                return $0.title.lowercased().hasPrefix(searchText)
            } else {
                return true
            }
        }
    }
    
    func getResult() throws(FilterCitiesUseCaseError) -> Array<CityViewModel> {
        guard cities != nil else {
            throw .inputNotSet
        }
        return cities
    }
}
