//
//  ToggleFavoriteUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import SwiftData

class ToggleFavoriteUseCaseFactory {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func create() -> some ToggleFavoriteUseCase {
        let localRepository = CityListLocalRepositoryFactory().create(with: context)
        let result = DefaultToggleFavoriteUseCase(localRepository: localRepository)
        return result
    }
}
