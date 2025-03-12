//
//  CityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

enum CityCreateLocalRepositoryError: Swift.Error {
    case notImplemented
}
protocol CityCreateLocalRepository {
    func create(city: City) throws(CityCreateLocalRepositoryError)
}

enum CityRemoveLocalRepositoryError: Swift.Error {
    case notImplemented
}
protocol CityRemoveLocalRepository {
    func remove(city: City) throws(CityRemoveLocalRepositoryError)
}

enum CityUpdateLocalRepositoryError: Swift.Error {
    case notImplemented
}
protocol CityUpdateLocalRepository {
    func update(city: City) throws(CityUpdateLocalRepositoryError)
}

enum CityListLocalRepositoryError: Swift.Error {
    case notImplemented
}
protocol CityListLocalRepository {
    func listAllCities() throws(CityListLocalRepositoryError) -> [City]
}
