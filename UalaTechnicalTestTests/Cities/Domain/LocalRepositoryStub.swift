//
//  LocalRepositoryStub.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

@testable import UalaTechnicalTest

class LocalRepositoryStub: CityLocalRepository {
    var cities: [City] = []
    var error: CityListLocalRepositoryError?
    func create(city: City) {
        cities.append(city)
    }
    
    func listAllCities() throws(CityListLocalRepositoryError) -> [City] {
        if let error {
            throw error
        }
        return cities
    }
    
    func remove(city: City) throws(CityRemoveLocalRepositoryError) {
        guard cities.contains(where: { $0.id == city.id }) else {
            throw .cityNotFoundInDB
        }
        cities.removeAll { $0.id == city.id }
    }
    
    func update(city: City) throws(CityUpdateLocalRepositoryError) {
        
    }
}
