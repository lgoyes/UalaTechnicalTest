//
//  MarkCityAsFavoriteUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

enum MarkCityAsFavoriteUseCaseError: Swift.Error {
    case newFavoriteNotSet, favoriteAlreadyExists
}

protocol MarkCityAsFavoriteUseCase: Command where ErrorType == MarkCityAsFavoriteUseCaseError {
    func set(newFavorite: City)
}

class DefaultMarkCityAsFavoriteUseCase: MarkCityAsFavoriteUseCase {
    
    private var newFavorite: City!
    private var localRepository: CityCreateLocalRepository
    
    init(localRepository: CityCreateLocalRepository) {
        self.localRepository = localRepository
    }
    
    func set(newFavorite: City) {
        self.newFavorite = newFavorite
    }
    
    func execute() async throws(MarkCityAsFavoriteUseCaseError) {
        try validateNewFavoriteSet()
        try await saveNewFavorite()
    }
    
    private func validateNewFavoriteSet() throws(MarkCityAsFavoriteUseCaseError) {
        if newFavorite == nil {
            throw .newFavoriteNotSet
        }
    }
    private func saveNewFavorite() async throws(MarkCityAsFavoriteUseCaseError) {
        do {
            try await localRepository.create(city: newFavorite)
        } catch {
            throw .favoriteAlreadyExists
        }
    }
}
