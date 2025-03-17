//
//  DBCityCreatorTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

final class DBCityCreatorTests {
    
    private let sut: DefaultDBCityCreator
    private var someDBCity: DBCity!
    private var someContext: ModelContext
    
    init() throws {
        someContext = ModelContextStubFactory().create()
        sut = DefaultDBCityCreator(context: someContext)
    }
    
    @Test("GIVEN context and some db city, WHEN creating a city, THEN it should add that item to context")
    func basicTest() async throws {
        GIVEN_someDBCity()
        WHEN_creatingACity()
        try THEN_itShouldAddItemToContext()
    }
    
    func GIVEN_someDBCity() {
        someDBCity = DBCityFactory.create()
    }
    
    func WHEN_creatingACity() {
        sut.create(city: someDBCity)
    }
    
    func THEN_itShouldAddItemToContext() throws {
        let result = try someContext.fetch(FetchDescriptor<DBCity>())[0]
        #expect(DBCityComparator.compare(result, someDBCity))
    }
}
