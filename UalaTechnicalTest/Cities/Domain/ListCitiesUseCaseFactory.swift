//
//  ListCitiesUseCaseFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

class ListCitiesUseCaseFactory {
    func create() -> ListCitiesUseCase {
        let repository = CityListRemoteRepositoryFactory().create()
        let result = DefaultListCitiesUseCase(repository: repository)
        return result
    }
}
