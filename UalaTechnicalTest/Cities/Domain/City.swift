//
//  City.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

struct City {
    let country: String
    let name: String
    let id: Int
    var favorite: Bool
    let coordinates: Coordinate
}
