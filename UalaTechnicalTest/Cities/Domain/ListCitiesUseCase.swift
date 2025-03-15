//
//  ListCitiesUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

enum ListCitiesUseCaseError: Swift.Error {
    case networkError
}

protocol ListCitiesUseCase: UseCase where Output == [City], ErrorType == ListCitiesUseCaseError {
    
}

class DefaultListCitiesUseCase: ListCitiesUseCase {
    private var result: [City]
    private var remoteEntries: [City]
    private var favoriteEntries: [City]
    private var error: ListCitiesUseCaseError?
    private var remoteRepository: CityListRemoteRepository
    private var localRepository: CityListLocalRepository
    
    init(remoteRepository: CityListRemoteRepository, localRepository: CityListLocalRepository) {
        self.result = []
        self.remoteEntries = []
        self.remoteRepository = remoteRepository
        self.favoriteEntries = []
        self.localRepository = localRepository
    }
    
    func getResult() throws(ListCitiesUseCaseError) -> [City] {
        if let error {
            throw error
        }
        return result
    }
    
    func execute() async throws(ListCitiesUseCaseError) {
        do {
            clearError()
            try fetchEntriesFromDisk()
            try await downloadEntries()
            mergeEntries()
            sortEntries()
        } catch {
            self.error = ListCitiesUseCaseError.networkError
            throw self.error!
        }
    }
    
    private func clearError() {
        error = nil
    }
    private func fetchEntriesFromDisk() throws {
        favoriteEntries = try localRepository.listAllCities()
    }
    private func downloadEntries() async throws {
        remoteEntries = try await remoteRepository.listAllCities()
    }
    
    private func mergeEntries() {
        initResultWithRemoteEntries()
        markFavoriteEntriesInResult()
    }
    private func initResultWithRemoteEntries() {
        result = remoteEntries
    }
    private func markFavoriteEntriesInResult() {
        for entryIndex in result.indices {
            if favoriteEntries.count == 0 { break }
            let entryUnderTest = result[entryIndex]
            if let associatedLocalEntryIndex = favoriteEntries.firstIndex(where: { $0.id == entryUnderTest.id }) {
                let associatedLocalEntry = favoriteEntries.remove(at: associatedLocalEntryIndex)
                result[entryIndex].favorite = associatedLocalEntry.favorite
            }
        }
    }
    private func sortEntries() {
        result.sort(by: { $0.name < $1.name })
    }
}
