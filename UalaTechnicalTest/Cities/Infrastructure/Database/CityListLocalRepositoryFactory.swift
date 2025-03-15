//
//  CityListLocalRepositoryFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import SwiftData

class CityListLocalRepositoryFactory {
    
    func create(with context: ModelContext) -> CityLocalRepository {
        let db = createDBFacade(with: context)
        let mapper = DBCityMapper()
        let result = DefaultCityLocalRepository(db: db, mapper: mapper)
        return result
    }
    
    private func createDBFacade(with context: ModelContext) -> DBFacade {
        let creator = DefaultDBCityCreator(context: context)
        let lister = DefaultDBCityLister(context: context)
        let remover = DefaultDBCityRemover(context: context)
        let result = DefaultDBFacade(creatable: creator, listable: lister, removable: remover)
        return result
    }
}
