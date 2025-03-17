//
//  CityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

enum CityCreateLocalRepositoryError: Swift.Error {
    case cityAlreadyExists, unexpectedError
}
protocol CityCreateLocalRepository {
    @MainActor func create(city: City) throws(CityCreateLocalRepositoryError)
}

enum CityRemoveLocalRepositoryError: Swift.Error {
    case cityNotFoundInDB, unexpectedError
}
protocol CityRemoveLocalRepository {
    @MainActor func remove(city: City) throws(CityRemoveLocalRepositoryError)
}

enum CityListLocalRepositoryError: Swift.Error {
    case couldNotListEntries
}
protocol CityListLocalRepository {
    @MainActor func listAllCities() throws(CityListLocalRepositoryError) -> [City]
}
