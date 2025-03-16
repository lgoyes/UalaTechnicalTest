//
//  MarkCityAsFavoriteUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

enum MarkCityAsFavoriteUseCaseError: Swift.Error {
    case newFavoriteNotSet, errorReadingDB
}

protocol MarkCityAsFavoriteUseCase: Command where ErrorType == MarkCityAsFavoriteUseCaseError {
    func set(newFavorite: City)
}

class DefaultMarkCityAsFavoriteUseCase: MarkCityAsFavoriteUseCase {
    typealias LocalRepository = CityListLocalRepository & CityCreateLocalRepository
    
    private var favoriteEntries: [City]
    private var newFavorite: City!
    private var localRepository: LocalRepository
    
    init(localRepository: LocalRepository) {
        self.favoriteEntries = []
        self.localRepository = localRepository
    }
    
    func set(newFavorite: City) {
        self.newFavorite = newFavorite
    }
    
    func execute() async throws(MarkCityAsFavoriteUseCaseError) {
        try validateNewFavoriteSet()
        try await fetchFavoriteEntriesFromDisk()
        if !isNewFavoriteAlreadyInList() {
            await saveNewFavorite()
        }
    }
    
    private func validateNewFavoriteSet() throws(MarkCityAsFavoriteUseCaseError) {
        if newFavorite == nil {
            throw .newFavoriteNotSet
        }
    }
    private func fetchFavoriteEntriesFromDisk() async throws(MarkCityAsFavoriteUseCaseError) {
        do {
            favoriteEntries = try await localRepository.listAllCities()
        } catch {
            throw MarkCityAsFavoriteUseCaseError.errorReadingDB
        }
    }
    private func isNewFavoriteAlreadyInList() -> Bool {
        return favoriteEntries.contains(where: { $0.id == newFavorite.id })
    }
    private func saveNewFavorite() async {
        await localRepository.create(city: newFavorite)
    }
}
