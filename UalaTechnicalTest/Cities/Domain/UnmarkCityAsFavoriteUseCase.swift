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
    typealias LocalRepository = CityListLocalRepository & CityRemoveLocalRepository
    
    private var favoriteEntries: [City]
    private var favoriteToRemove: City!
    private var localRepository: LocalRepository
    
    init(localRepository: LocalRepository) {
        self.favoriteEntries = []
        self.localRepository = localRepository
    }
    
    func set(favoriteToRemove: City) {
        self.favoriteToRemove = favoriteToRemove
    }
    
    func execute() async throws(UnmarkCityAsFavoriteUseCaseError) {
        try validateNewFavoriteSet()
        try tryToRemoveFavorite()
    }
    
    private func validateNewFavoriteSet() throws(UnmarkCityAsFavoriteUseCaseError) {
        if favoriteToRemove == nil {
            throw .favoriteToRemoveNotSet
        }
    }
    private func tryToRemoveFavorite() throws(UnmarkCityAsFavoriteUseCaseError) {
        do {
            try localRepository.remove(city: favoriteToRemove)
        } catch {
            throw UnmarkCityAsFavoriteUseCaseError.favoriteNotFound
        }
    }
}
