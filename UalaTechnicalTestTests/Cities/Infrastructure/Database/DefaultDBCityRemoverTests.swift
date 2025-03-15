//
//  DefaultDBCityRemoverTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

final class DefaultDBCityRemoverTests {
    
    private let sut: DefaultDBCityRemover
    private var someDBCity: DBCity!
    private var someContext: ModelContext
    
    init() throws {
        someContext = ModelContextStubFactory().create()
        sut = DefaultDBCityRemover(context: someContext)
    }
    
    @Test("GIVEN context and some db city, WHEN removing a city, THEN it should clean the context")
    func basicTest() async throws {
        GIVEN_someDBCity()
        WHEN_removingACity()
        try THEN_itShouldCleanTheContext()
    }
    
    func GIVEN_someDBCity() {
        someDBCity = DBCityFactory.create()
        someContext.insert(someDBCity)
    }
    
    func WHEN_removingACity() {
        sut.remove(city: someDBCity)
    }
    
    func THEN_itShouldCleanTheContext() throws {
        #expect(try someContext.fetch(FetchDescriptor<DBCity>()).count == 0)
    }
}
