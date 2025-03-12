//
//  DefaultListCitiesUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
@testable import UalaTechnicalTest

class CityListRemoteRepositoryStub: CityListRemoteRepository {
    var result: [City] = []
    func listAllCities() async throws(CityListRemoteRepositoryError) -> [City] {
        return result
    }
}

class DefaultListCitiesUseCaseTests {
    
    let sut: DefaultListCitiesUseCase
    let repository: CityListRemoteRepositoryStub
    init() {
        repository = .init()
        sut = DefaultListCitiesUseCase(repository: repository)
    }
    
    @Test("display name")
    func name() {
        
    }
}
