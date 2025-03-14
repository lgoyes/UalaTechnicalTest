//
//  CityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

protocol CityCreateLocalRepository {
    func create(city: City)
}

enum CityRemoveLocalRepositoryError: Swift.Error {
    case cityNotFoundInDB
}
protocol CityRemoveLocalRepository {
    func remove(city: City) throws(CityRemoveLocalRepositoryError)
}

enum CityUpdateLocalRepositoryError: Swift.Error {
    case cityNotFoundInDB
}
protocol CityUpdateLocalRepository {
    func update(city: City) throws(CityUpdateLocalRepositoryError)
}

enum CityListLocalRepositoryError: Swift.Error {
    case couldNotListEntries
}
protocol CityListLocalRepository {
    func listAllCities() throws(CityListLocalRepositoryError) -> [City]
}
