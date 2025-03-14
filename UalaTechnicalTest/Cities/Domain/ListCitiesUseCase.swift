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
    private var error: ListCitiesUseCaseError?
    private var repository: CityListRemoteRepository
    
    init(repository: CityListRemoteRepository) {
        self.result = []
        self.repository = repository
    }
    
    func execute() async throws(ListCitiesUseCaseError) {
        do {
            error = nil
            result = try await repository.listAllCities()
        } catch {
            self.error = ListCitiesUseCaseError.networkError
            throw self.error!
        }
    }
    
    func getResult() throws(ListCitiesUseCaseError) -> [City] {
        if let error {
            throw error
        }
        return result
    }
}
