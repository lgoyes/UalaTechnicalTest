//
//  UnmarkCityAsFavoriteUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import SwiftData

class UnmarkCityAsFavoriteUseCaseFactory {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func create() -> some UnmarkCityAsFavoriteUseCase {
        let localRepository = CityListLocalRepositoryFactory().create(with: context)
        let result = DefaultUnmarkCityAsFavoriteUseCase(localRepository: localRepository)
        return result
    }
}
