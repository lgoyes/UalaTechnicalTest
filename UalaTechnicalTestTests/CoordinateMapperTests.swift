//
//  CoordinateMapperTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Testing
@testable import UalaTechnicalTest

extension Coordinate: @retroactive Equatable {
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

struct CoordinateFactory {
    static func createSomeCoordinates() -> Coordinate {
        Coordinate(latitude: CityConstant.someLatitude, longitude: CityConstant.someLongitude)
    }
    
    static func createSomeAPICoordinates() -> APICoordinate {
        APICoordinate(latitude: CityConstant.someLatitude, longitude: CityConstant.someLongitude)
    }
}

struct CoordinateMapperTests {
    
    let sut = CoordinateMapper()

    @Test("GIVEN some APICoordinate, WHEN map, THEN return a valid Coordinate", arguments: [(CoordinateFactory.createSomeAPICoordinates(), CoordinateFactory.createSomeCoordinates())])
    func map(input: APICoordinate, expectedResult: Coordinate) {
        let result = sut.map(input)
        #expect(result == expectedResult)
    }
}
