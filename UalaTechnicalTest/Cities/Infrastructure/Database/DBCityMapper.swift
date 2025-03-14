//
//  DBCityMapper.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

protocol DBCityMapperProtocol {
    func map(_ city: DBCity) -> City
    func invert(_ city: City) -> DBCity
}

class DBCityMapper: DBCityMapperProtocol {
    func map(_ city: DBCity) -> City {
        .init(country: city.country, name: city.name, id: city.id, favorite: city.favorite, coordinates: Coordinate(latitude: city.latitude, longitude: city.longitude))
    }
    
    func invert(_ city: City) -> DBCity {
        DBCity(country: city.country, name: city.name, id: city.id, latitude: city.coordinates.latitude, longitude: city.coordinates.longitude, favorite: city.favorite)
    }
}
