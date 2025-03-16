//
//  CityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

@MainActor
protocol CityCreateLocalRepository {
    func create(city: City)
}

enum CityRemoveLocalRepositoryError: Swift.Error {
    case cityNotFoundInDB
}
@MainActor
protocol CityRemoveLocalRepository {
    func remove(city: City) throws(CityRemoveLocalRepositoryError)
}

enum CityUpdateLocalRepositoryError: Swift.Error {
    case cityNotFoundInDB
}
@MainActor
protocol CityUpdateLocalRepository {
    func update(city: City) throws(CityUpdateLocalRepositoryError)
}

enum CityListLocalRepositoryError: Swift.Error {
    case couldNotListEntries
}
@MainActor
protocol CityListLocalRepository {
    func listAllCities() throws(CityListLocalRepositoryError) -> [City]
}
