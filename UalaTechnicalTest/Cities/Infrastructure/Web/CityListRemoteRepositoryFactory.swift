//
//  CityListRemoteRepositoryFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

class CityListRemoteRepositoryFactory {
    private enum Constant {
        static let baseURLKey = "cities_url"
    }
    func create() -> CityListRemoteRepository {
        let client = APIClient()
        let baseURL = getBaseURL()
        let coordinateMapper = CoordinateMapper()
        let cityMapper = CityMapper(coordinateMapper: coordinateMapper)
        let result = DefaultCityListRemoteRepository(apiClient: client, baseURL: baseURL, cityMapper: cityMapper)
        return result
    }
    
    private func getBaseURL() -> String {
        let settingsRetriever = SettingsRetrieverFactory().create()
        let settings = settingsRetriever.retrieve()
        guard let baseURL = settings[Constant.baseURLKey] else {
            fatalError("This key MUST exist.")
        }
        return baseURL
    }
}
