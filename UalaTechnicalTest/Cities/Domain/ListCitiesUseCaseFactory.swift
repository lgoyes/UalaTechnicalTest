//
//  ListCitiesUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftData

class ListCitiesUseCaseFactory {
    private var logger: Logger?
    private var context: ModelContext
    
    init(context: ModelContext, logger: Logger? = nil) {
        self.context = context
        self.logger = logger
    }

    func create() -> any ListCitiesUseCase {
        let remoteRepository = CityListRemoteRepositoryFactory(logger: logger).create()
        let localRepository = CityListLocalRepositoryFactory().create(with: context)
        let result = DefaultListCitiesUseCase(remoteRepository: remoteRepository, localRepository: localRepository)
        return result
    }
}
