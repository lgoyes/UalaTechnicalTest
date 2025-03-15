//
//  MarkCityAsFavoriteUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import SwiftData

class MarkCityAsFavoriteUseCaseFactory {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func create() -> some MarkCityAsFavoriteUseCase {
        let localRepository = CityListLocalRepositoryFactory().create(with: context)
        let result = DefaultMarkCityAsFavoriteUseCase(localRepository: localRepository)
        return result
    }
}
