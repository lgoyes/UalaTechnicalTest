//
//  CityFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

@testable import UalaTechnicalTest

struct CityFactory {
    static func create() -> City {
        City(country: CityConstant.someCountry, name: CityConstant.someName, id: CityConstant.someId, favorite: CityConstant.favorite, coordinates: CoordinateFactory.createSomeCoordinates())
    }
}
