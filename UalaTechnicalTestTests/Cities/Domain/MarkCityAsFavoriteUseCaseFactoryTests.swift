//
//  MarkCityAsFavoriteUseCaseFactoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class MarkCityAsFavoriteUseCaseFactoryTests {

    private let sut : MarkCityAsFavoriteUseCaseFactory
    private var result: (any MarkCityAsFavoriteUseCase)!
    
    init() {
        let context = ModelContextStubFactory().create()
        sut = MarkCityAsFavoriteUseCaseFactory(context: context)
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
        #expect(result is DefaultMarkCityAsFavoriteUseCase)
    }
}
