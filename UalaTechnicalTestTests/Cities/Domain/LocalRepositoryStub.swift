//
//  LocalRepositoryStub.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

@testable import UalaTechnicalTest

class LocalRepositoryStub: CityLocalRepository {
    var result: [City] = []
    var listError: CityListLocalRepositoryError?
    func create(city: City) throws(CityCreateLocalRepositoryError) {
        if result.contains(where: { $0.id == city.id }) {
            throw .cityAlreadyExists
        }
        result.append(city)
    }
    
    func listAllCities() throws(CityListLocalRepositoryError) -> [City] {
        if let listError {
            throw listError
        }
        return result
    }
    
    func remove(city: City) throws(CityRemoveLocalRepositoryError) {
        guard result.contains(where: { $0.id == city.id }) else {
            throw .cityNotFoundInDB
        }
        result.removeAll { $0.id == city.id }
    }
}
