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
    
    private var entries: [City]
    private var newFavorite: City!
    private var localRepository: LocalRepository
    
    init(localRepository: LocalRepository) {
        self.entries = []
        self.localRepository = localRepository
    }
    
    func set(newFavorite: City) {
        self.newFavorite = newFavorite
    }
    
    func execute() async throws(MarkCityAsFavoriteUseCaseError) {
        try validateNewFavoriteSet()
        try fetchEntriesFromDisk()
        if !isNewFavoriteAlreadyInList() {
            saveNewFavorite()
        }
    }
    
    private func validateNewFavoriteSet() throws(MarkCityAsFavoriteUseCaseError) {
        if newFavorite == nil {
            throw .newFavoriteNotSet
        }
    }
    private func fetchEntriesFromDisk() throws(MarkCityAsFavoriteUseCaseError) {
        do {
            entries = try localRepository.listAllCities()
        } catch {
            throw MarkCityAsFavoriteUseCaseError.errorReadingDB
        }
    }
    private func isNewFavoriteAlreadyInList() -> Bool {
        return entries.contains(where: { $0.id == newFavorite.id })
    }
    private func saveNewFavorite() {
        localRepository.create(city: newFavorite)
    }
}
