//
//  APICoordinateMapperTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Testing
@testable import UalaTechnicalTest

extension APICoordinate: @retroactive Equatable {
    public static func == (lhs: APICoordinate, rhs: APICoordinate) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

extension Coordinate: @retroactive Equatable {
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

struct CoordinateFactory {
    static func createSomeCoordinates(latitude: Double? = nil, longitude: Double? = nil) -> Coordinate {
        Coordinate(latitude: latitude ?? CityConstant.someLatitude, longitude: longitude ?? CityConstant.someLongitude)
    }
    
    static func createSomeAPICoordinates() -> APICoordinate {
        APICoordinate(latitude: CityConstant.someLatitude, longitude: CityConstant.someLongitude)
    }
}

final class APICoordinateMapperTests {
    
    private let sut = APICoordinateMapper()
    private var apiCoordinate: APICoordinate!
    private var result: Coordinate!

    @Test("GIVEN some APICoordinate, WHEN map, THEN return a valid Coordinate")
    func map() {
        GIVEN_someAPICoordinate()
        WHEN_map()
        THEN_itShouldCreateSomeValidCoordinate()
    }
    
    func GIVEN_someAPICoordinate() {
        apiCoordinate = CoordinateFactory.createSomeAPICoordinates()
    }
    
    func WHEN_map() {
        result = sut.map(apiCoordinate)
    }
    
    func THEN_itShouldCreateSomeValidCoordinate() {
        #expect(result == CoordinateFactory.createSomeCoordinates())
    }
    
    // Using arguments just for showing-off
    @Test("GIVEN some Coordinate, WHEN invert, THEN return a valid APICoordinate", arguments: [(CoordinateFactory.createSomeCoordinates(), CoordinateFactory.createSomeAPICoordinates())])
    func map(input: Coordinate, expectedResult: APICoordinate) {
        let result = sut.invert(input)
        #expect(result == expectedResult)
    }
}
