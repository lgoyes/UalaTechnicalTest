//
//  UnmarkCityAsFavoriteUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

enum UnmarkCityAsFavoriteUseCaseError: Swift.Error {
    case favoriteToRemoveNotSet, errorReadingDB, favoriteNotFound
}

protocol UnmarkCityAsFavoriteUseCase: Command where ErrorType == UnmarkCityAsFavoriteUseCaseError {
    func set(favoriteToRemove: City)
}

class DefaultUnmarkCityAsFavoriteUseCase: UnmarkCityAsFavoriteUseCase {
    typealias LocalRepository = CityListLocalRepository & CityRemoveLocalRepository
    
    private var entries: [City]
    private var favoriteToRemove: City!
    private var localRepository: LocalRepository
    
    init(localRepository: LocalRepository) {
        self.entries = []
        self.localRepository = localRepository
    }
    
    func set(favoriteToRemove: City) {
        self.favoriteToRemove = favoriteToRemove
    }
    
    func execute() async throws(UnmarkCityAsFavoriteUseCaseError) {
        try validateNewFavoriteSet()
        try fetchEntriesFromDisk()
        if isFavoriteToRemoveAlreadyInList() {
            try removeFavorite()
        }
    }
    
    private func validateNewFavoriteSet() throws(UnmarkCityAsFavoriteUseCaseError) {
        if favoriteToRemove == nil {
            throw .favoriteToRemoveNotSet
        }
    }
    private func fetchEntriesFromDisk() throws(UnmarkCityAsFavoriteUseCaseError) {
        do {
            entries = try localRepository.listAllCities()
        } catch {
            throw UnmarkCityAsFavoriteUseCaseError.errorReadingDB
        }
    }
    private func isFavoriteToRemoveAlreadyInList() -> Bool {
        return entries.contains(where: { $0.id == favoriteToRemove.id })
    }
    private func removeFavorite() throws(UnmarkCityAsFavoriteUseCaseError) {
        do {
            try localRepository.remove(city: favoriteToRemove)
        } catch {
            throw UnmarkCityAsFavoriteUseCaseError.favoriteNotFound
        }
    }
}
