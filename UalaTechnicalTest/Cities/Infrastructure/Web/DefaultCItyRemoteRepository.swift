//
//  DefaultCItyRemoteRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Foundation

class DefaultCityListRemoteRepository: CityListRemoteRepository {
    private let apiClient: RESTAPIFetchable
    private let baseURL: String
    private let cityMapper: CityMapper
    
    init(apiClient: RESTAPIFetchable, baseURL: String, cityMapper: CityMapper) {
        self.apiClient = apiClient
        self.baseURL = baseURL
        self.cityMapper = cityMapper
    }
    
    func listAllCities() async throws(CityListRemoteRepositoryError) -> [City] {
        do {
            let response: [APICity] = try await apiClient.fetchData(from: baseURL)
            return response.map { cityMapper.map($0) }
        } catch {
            throw .networkError
        }
    }
}
