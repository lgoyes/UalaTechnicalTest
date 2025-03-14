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
    private var logger: Logger?
    init(logger: Logger? = nil) {
        self.logger = logger
    }
    
    func create() -> CityListRemoteRepository {
        var client: RESTAPIFetchable = APIClient()
        if let logger {
            client = LoggingAPIClient(decorated: client, logger: logger)
        }
        let baseURL = getBaseURL()
        let coordinateMapper = APICoordinateMapper()
        let cityMapper = APICityMapper(coordinateMapper: coordinateMapper)
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
