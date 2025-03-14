//
//  DBCityFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

@testable import UalaTechnicalTest

struct DBCityFactory {
    static func create() -> DBCity {
        return DBCity(country: CityConstant.someCountry, name: CityConstant.someName, id: CityConstant.someId, latitude: CityConstant.someLatitude, longitude: CityConstant.someLongitude, favorite: CityConstant.favorite)
    }
}
