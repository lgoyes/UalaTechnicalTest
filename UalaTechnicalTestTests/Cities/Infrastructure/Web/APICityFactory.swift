//
//  APICityFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

@testable import UalaTechnicalTest

struct APICityFactory {
    static func create() -> APICity {
        APICity(country: CityConstant.someCountry, name: CityConstant.someName, id: CityConstant.someId, coordinates: CoordinateFactory.createSomeAPICoordinates())
    }
}
