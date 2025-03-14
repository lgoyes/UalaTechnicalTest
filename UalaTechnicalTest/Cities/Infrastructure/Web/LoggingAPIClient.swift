//
//  LoggingAPIClient.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import Foundation

class LoggingAPIClient: RESTAPIFetchable {

    private let decorated: RESTAPIFetchable
    private let logger: Logger

    init(decorated: RESTAPIFetchable, logger: Logger) {
        self.decorated = decorated
        self.logger = logger
    }
    
    func fetchData<T>(from urlString: String) async throws(RESTAPIFetchableError) -> T where T : Decodable {
        do {
            return try await self.decorated.fetchData(from: urlString)
        } catch {
            let message: String
            switch error {
            case .badURL:
                message = "Please check the URL"
            case .invalidResponse:
                message = "Response might not be HTTPURLResponse or its status might not be appropriate"
            case .connectionFailed:
                message = "Could not perform request"
            case .decodingFailed(let error):
                message = "There was an error decoding the response: \((error as NSError).userInfo.description)"
            }
            self.logger.log(message, level: .error)
            throw error
        }
    }
    
}
