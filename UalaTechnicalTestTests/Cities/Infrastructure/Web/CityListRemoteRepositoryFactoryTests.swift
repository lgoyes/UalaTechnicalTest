//
//  CityListRemoteRepositoryFactoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class CityListRemoteRepositoryFactoryTests {
    
    private let sut = CityListRemoteRepositoryFactory()
    private var result: CityListRemoteRepository!

    @Test("WHEN create, THEN it should create some valid repository")
    func map() {
        WHEN_create()
        THEN_itShouldCreateSomeValidRepository()
    }
    
    func WHEN_create() {
        result = sut.create()
    }
    
    func THEN_itShouldCreateSomeValidRepository() {
        #expect(result is DefaultCityListRemoteRepository)
    }
}
