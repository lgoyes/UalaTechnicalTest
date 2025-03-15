//
//  CityFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

@testable import UalaTechnicalTest

struct CityFactory {
    static func create(country: String? = nil, name: String? = nil, id: Int? = nil, favorite: Bool? = nil, latitude: Double? = nil, longitude: Double? = nil) -> City {
        City(country: country ?? CityConstant.someCountry, name: name ?? CityConstant.someName, id: id ?? CityConstant.someId, favorite: favorite ?? CityConstant.favorite, coordinates: CoordinateFactory.createSomeCoordinates(latitude: latitude, longitude: longitude))
    }
}
