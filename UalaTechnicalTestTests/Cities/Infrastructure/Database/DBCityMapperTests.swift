//
//  DBCityMapperTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import Testing
@testable import UalaTechnicalTest

struct DBCityComparator {
    static func compare(_ lhs: DBCity,_ rhs: DBCity) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.favorite == rhs.favorite &&
        lhs.country == rhs.country &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

final class DBCityMapperTests {
    
    private let sut = DBCityMapper()
    private var dbCity: DBCity!
    private var result: City!

    @Test("GIVEN some DBCity, WHEN map, THEN return a valid City")
    func map() {
        GIVEN_someDBCity()
        WHEN_map()
        THEN_itShouldCreateSomeValidCity()
    }
    
    func GIVEN_someDBCity() {
        dbCity = DBCityFactory.create()
    }
    
    func WHEN_map() {
        result = sut.map(dbCity)
    }
    
    func THEN_itShouldCreateSomeValidCity() {
        #expect(result == CityFactory.create())
    }
    
    @Test("GIVEN some City, WHEN invert, THEN return a valid DBCity")
    func invert() {
        let input = CityFactory.create()
        let result = sut.invert(input)
        let expectedResult = DBCityFactory.create()
        #expect(DBCityComparator.compare(result,expectedResult))
    }
}
