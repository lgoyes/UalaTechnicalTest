//
//  City.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

class Coordinate {
    let latitude: Double
    let longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City {
    let country: String
    let name: String
    let id: Int
    var favorite: Bool
    let coordinates: Coordinate
    init(country: String, name: String, id: Int, favorite: Bool, coordinates: Coordinate) {
        self.country = country
        self.name = name
        self.id = id
        self.favorite = favorite
        self.coordinates = coordinates
    }
}
