//
//  DBCityFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

@testable import UalaTechnicalTest

struct DBCityFactory {
    static func create() -> DBCity {
        return DBCity(country: "CO", name: "Medellín", id: 1, latitude: 1.2, longitude: 3.4)
    }
}
