//
//  ListCitiesUseCase.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

enum ListCitiesUseCaseError: Swift.Error {
    case networkError
}

protocol ListCitiesUseCase: UseCase where Output == [City] {
    
}

class DefaultListCitiesUseCase: ListCitiesUseCase {
    private var result: [City]
    private var repository: CityListRemoteRepository
    
    init(repository: CityListRemoteRepository) {
        self.result = []
        self.repository = repository
    }
    
    func execute() async throws(ListCitiesUseCaseError) {
        do {
            result = try await repository.listAllCities()
        } catch {
            throw .networkError
        }
    }
    
    func getResult() throws -> [City] {
        return result
    }
}
