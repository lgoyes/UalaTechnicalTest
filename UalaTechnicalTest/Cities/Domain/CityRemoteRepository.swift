//
//  CityRemoteRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

enum CityListRemoteRepositoryError: Swift.Error {
    case networkError
}

protocol CityListRemoteRepository {
    func listAllCities() async throws(CityListRemoteRepositoryError)-> [City]
}
