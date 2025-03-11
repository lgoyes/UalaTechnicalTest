//
//  APIClient.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation

protocol RESTAPIFetchable {
    func fetchData<T: Decodable>(from urlString: String) async throws -> T
}

class APIClient: RESTAPIFetchable {
    enum Error: Swift.Error, Equatable {
        case badURL, invalidResponse, connectionFailed, decodingFailed
    }
    private struct Constant {
        static let validStatusCodeRange: Range<Int> = 200..<300
    }
    private let decoder = JSONDecoder()
    
    func fetchData<T: Decodable>(from urlString: String) async throws(APIClient.Error) -> T {
        guard let url = URL(string: urlString) else {
            throw .badURL
        }
        
        let (data, response) : (Data, URLResponse)
        do {
            (data, response) = try await downloadData(from: url)
        } catch {
            throw .connectionFailed
        }
        
        guard isResponseValid(response) else {
            throw .invalidResponse
        }
        
        let result: T
        do {
            result = try decoder.decode(T.self, from: data)
        } catch {
            throw .decodingFailed
        }
        
        return result
    }
    
    func downloadData(from url: URL) async throws-> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }
    
    func isResponseValid(_ response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return Constant.validStatusCodeRange.contains(httpResponse.statusCode)
    }
}
