//
//  UnmarkCityAsFavoriteUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

enum UnmarkCityAsFavoriteUseCaseError: Swift.Error {
    case favoriteToRemoveNotSet, favoriteNotFound
}

protocol UnmarkCityAsFavoriteUseCase: Command where ErrorType == UnmarkCityAsFavoriteUseCaseError {
    func set(favoriteToRemove: City)
}

class DefaultUnmarkCityAsFavoriteUseCase: UnmarkCityAsFavoriteUseCase {
    
    private var favoriteToRemove: City!
    private var localRepository: CityRemoveLocalRepository
    
    init(localRepository: CityRemoveLocalRepository) {
        self.localRepository = localRepository
    }
    
    func set(favoriteToRemove: City) {
        self.favoriteToRemove = favoriteToRemove
    }
    
    func execute() async throws(UnmarkCityAsFavoriteUseCaseError) {
        try validateFavoriteToRemoveSet()
        try await tryToRemoveFavorite()
    }
    
    private func validateFavoriteToRemoveSet() throws(UnmarkCityAsFavoriteUseCaseError) {
        if favoriteToRemove == nil {
            throw .favoriteToRemoveNotSet
        }
    }
    private func tryToRemoveFavorite() async throws(UnmarkCityAsFavoriteUseCaseError) {
        do {
            try await localRepository.remove(city: favoriteToRemove)
        } catch {
            throw UnmarkCityAsFavoriteUseCaseError.favoriteNotFound
        }
    }
}
