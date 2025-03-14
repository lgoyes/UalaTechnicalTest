//
//  ListCitiesUseCaseFactoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class ListCitiesUseCaseFactoryTests {
    
    private let sut : ListCitiesUseCaseFactory
    private var result: (any UseCase)!
    
    init() {
        let context = ModelContextStubFactory().create()
        sut = ListCitiesUseCaseFactory(context: context)
    }

    @Test("WHEN create, THEN it should create some valid use case")
    func map() {
        WHEN_create()
        THEN_itShouldCreateSomeValidUseCase()
    }
    
    func WHEN_create() {
        result = sut.create()
    }
    
    func THEN_itShouldCreateSomeValidUseCase() {
        #expect(result is DefaultListCitiesUseCase)
    }
}
