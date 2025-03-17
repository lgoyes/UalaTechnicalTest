//
//  ToggleFavoriteUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import Foundation

enum ToggleFavoriteUseCaseError: Swift.Error {
    case missingRawCities, missingFavoriteCandidate, favoriteNotFound, favoriteAlreadyExists
}
protocol ToggleFavoriteUseCase: UseCase where ErrorType == ToggleFavoriteUseCaseError, Output == [City] {
    func set(rawCities: inout [City])
    func set(favoriteCandidateId: Int)
}

class DefaultToggleFavoriteUseCase: ToggleFavoriteUseCase {

    private var cities: [City]!
    private var favoriteCandidateId: Int!
    private var cityForUpdate: City!
    private var localRepository: CityRemoveLocalRepository & CityCreateLocalRepository
    
    init(localRepository: CityRemoveLocalRepository & CityCreateLocalRepository) {
        self.localRepository = localRepository
    }
    
    func set(rawCities: inout [City]) {
        self.cities = rawCities
    }
    
    func set(favoriteCandidateId: Int) {
        self.favoriteCandidateId = favoriteCandidateId
    }
    
    func execute() async throws(ToggleFavoriteUseCaseError) {
        guard cities != nil else {
            throw .missingRawCities
        }
        guard favoriteCandidateId != nil else {
            throw .missingFavoriteCandidate
        }
        guard let updatedCityIndex = cities.firstIndex(where: { $0.id == favoriteCandidateId } ) else {
            return
        }
        cityForUpdate = cities[updatedCityIndex]
        
        if cityForUpdate.favorite {
            try await tryToRemoveFavorite()
        } else {
            try await tryToCreateNewFavorite()
        }
        
        await toggleFavoriteInRawCities(updatedCityIndex: updatedCityIndex)
    }
    
    private func tryToCreateNewFavorite() async throws(ToggleFavoriteUseCaseError) {
        do {
            try await localRepository.create(city: cityForUpdate)
        } catch {
            throw .favoriteAlreadyExists
        }
    }
    
    private func tryToRemoveFavorite() async throws(ToggleFavoriteUseCaseError) {
        do {
            try await localRepository.remove(city: cityForUpdate)
        } catch {
            throw .favoriteNotFound
        }
    }
    
    @MainActor
    private func toggleFavoriteInRawCities(updatedCityIndex: Int) {
        cities[updatedCityIndex].favorite.toggle()
    }
    
    func getResult() throws(ToggleFavoriteUseCaseError) -> Array<City> {
        guard cities != nil else {
            throw .missingRawCities
        }
        return cities
    }
    
}
