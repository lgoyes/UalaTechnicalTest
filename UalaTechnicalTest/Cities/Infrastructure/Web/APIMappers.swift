//
//  APIMappers.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

protocol APICityMapperProtocol {
    func map(_ city: APICity) -> City
    func invert(_ city: City) -> APICity
}

class APICityMapper: APICityMapperProtocol {
    private let coordinateMapper: APICoordinateMapper
    init(coordinateMapper: APICoordinateMapper) {
        self.coordinateMapper = coordinateMapper
    }
    
    func map(_ city: APICity) -> City {
        .init(country: city.country, name: city.name, id: city.id, favorite: false, coordinates: coordinateMapper.map(city.coordinates))
    }
    
    func invert(_ city: City) -> APICity {
        .init(country: city.country, name: city.name, id: city.id, coordinates: coordinateMapper.invert(city.coordinates))
    }
}

class APICoordinateMapper {
    func map(_ coordinate: APICoordinate) -> Coordinate {
        .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func invert(_ coordinate: Coordinate) -> APICoordinate {
        .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
