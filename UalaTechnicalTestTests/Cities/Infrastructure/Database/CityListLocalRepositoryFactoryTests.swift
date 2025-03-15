//
//  CityListLocalRepositoryFactoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

class CityListLocalRepositoryFactoryTests {
    @Test("GIVEN some contex t, WHEN create, THEN it should create a valid repository")
    func create() {
        let context = ModelContextStubFactory().create()
        let sut = CityListLocalRepositoryFactory()
        let result = sut.create(with: context)
        #expect(result is DefaultCityLocalRepository)
    }
}
