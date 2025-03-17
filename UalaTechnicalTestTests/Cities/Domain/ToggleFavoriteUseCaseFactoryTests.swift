//
//  ToggleFavoriteUseCaseFactoryTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class ToggleFavoriteUseCaseFactoryTests {

    private let sut : ToggleFavoriteUseCaseFactory
    private var result: (any ToggleFavoriteUseCase)!
    
    init() {
        let context = ModelContextStubFactory().create()
        sut = ToggleFavoriteUseCaseFactory(context: context)
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
        #expect(result is DefaultToggleFavoriteUseCase)
    }
}
