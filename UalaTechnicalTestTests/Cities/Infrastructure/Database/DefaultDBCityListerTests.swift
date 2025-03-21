//
//  DefaultDBCityListerTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

final class DefaultDBCityListerTests {
    
    private let sut: DefaultDBCityLister
    private var someDBCity: DBCity!
    private var someContext: ModelContext
    private var result: [DBCity]!
    
    init() throws {
        someContext = ModelContextStubFactory().create()
        sut = DefaultDBCityLister(context: someContext)
    }
    
    @Test("GIVEN some db city in context, WHEN listing, THEN it should return items from the context")
    func basicTest() async throws {
        GIVEN_someDBCity()
        try WHEN_listing()
        THEN_itShouldReturnItems()
    }
    
    func GIVEN_someDBCity() {
        someDBCity = DBCityFactory.create()
        someContext.insert(someDBCity)
    }
    
    func WHEN_listing() throws {
        result = try sut.listAllCities()
    }
    
    func THEN_itShouldReturnItems() {
        #expect(result[0] == someDBCity)
    }
}
