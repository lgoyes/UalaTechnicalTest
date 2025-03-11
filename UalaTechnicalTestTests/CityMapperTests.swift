//
//  CityMapperTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Testing
@testable import UalaTechnicalTest

extension APICity: @retroactive Equatable {
    public static func == (lhs: APICity, rhs: APICity) -> Bool {
        lhs.country == rhs.country &&
        lhs.name == rhs.name &&
        lhs.id == rhs.id &&
        lhs.coordinates == rhs.coordinates
    }
}

extension City: @retroactive Equatable {
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.country == rhs.country &&
        lhs.name == rhs.name &&
        lhs.id == rhs.id &&
        lhs.coordinates == rhs.coordinates
    }
}

struct CityFactory {
    static func createSomeCity() -> City {
        City(country: CityConstant.someCountry, name: CityConstant.someName, id: CityConstant.someId, coordinates: CoordinateFactory.createSomeCoordinates())
    }
    
    static func createSomeAPICity() -> APICity {
        APICity(country: CityConstant.someCountry, name: CityConstant.someName, id: CityConstant.someId, coordinates: CoordinateFactory.createSomeAPICoordinates())
    }
}

struct CityMapperTests {
    
    let sut = CityMapper(coordinateMapper: CoordinateMapper())

    @Test("GIVEN some APICity, WHEN map, THEN return a valid City", arguments: [(CityFactory.createSomeAPICity(), CityFactory.createSomeCity())])
    func map(input: APICity, expectedResult: City) {
        let result = sut.map(input)
        #expect(result == expectedResult)
    }
    
    @Test("GIVEN some City, WHEN invert, THEN return a valid APICity", arguments: [(CityFactory.createSomeCity(), CityFactory.createSomeAPICity())])
    func invert(input: City, expectedResult: APICity) {
        let result = sut.invert(input)
        #expect(result == expectedResult)
    }

}
