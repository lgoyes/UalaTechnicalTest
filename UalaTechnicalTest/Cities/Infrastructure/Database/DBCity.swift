//
//  DBCity.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftData

@Model
final class DBCity {
    var country: String
    var name: String
    var id: Int
    var latitude: Double
    var longitude: Double
    var favorite: Bool
    
    init (country: String, name: String, id: Int, latitude: Double, longitude: Double, favorite: Bool) {
        self.country = country
        self.name = name
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.favorite = favorite
    }
}
