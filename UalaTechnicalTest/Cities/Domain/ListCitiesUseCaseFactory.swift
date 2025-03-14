//
//  ListCitiesUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

class ListCitiesUseCaseFactory {
    private var logger: Logger?
    init(logger: Logger? = nil) {
        self.logger = logger
    }

    func create() -> some UseCase {
        let repository = CityListRemoteRepositoryFactory(logger: logger).create()
        let result = DefaultListCitiesUseCase(repository: repository)
        return result
    }
}
