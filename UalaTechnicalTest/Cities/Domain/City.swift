//
//  City.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

struct Coordinate {
    let latitude: Double
    let longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct City {
    let country: String
    let name: String
    let id: Int
    let favorite: Bool
    let coordinates: Coordinate
    init(country: String, name: String, id: Int, favorite: Bool, coordinates: Coordinate) {
        self.country = country
        self.name = name
        self.id = id
        self.favorite = favorite
        self.coordinates = coordinates
    }
    
    func toggleFavorite() -> City {
        return City(country: country, name: name, id: id, favorite: !favorite, coordinates: coordinates)
    }
}
