//
//  APIClientTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation
import Testing
@testable import UalaTechnicalTest

class TestingAPIClient: APIClient {
    enum Error: Swift.Error {
        case someError
    }
    var downloadedData: Data!
    var response: URLResponse!
    override func downloadData(from url: URL) async throws -> (Data, URLResponse) {
        guard let downloadedData, let response else {
            throw Error.someError
        }
        return (downloadedData, response)
    }
}

struct DummyType: Codable {
    
}

struct APIClientTests {
    
    let sut = TestingAPIClient()
    
    @Test("GIVEN some invalid URL, WHEN call fetch data, THEN it should throw an invalidURL error")
    func invalidURL() async {
        await #expect(performing: {
            let _: DummyType = try await sut.fetchData(from: "")
        }, throws: { error in
            guard let error = error as? APIClient.Error else {
                return false
            }
            return error == .badURL
        })
    }
    
    @Test("GIVEN some valid URL, and a connection error, WHEN call fetch data, THEN it should throw a connectionFailed error")
    func connectionFailed() async {
        await #expect(performing: {
            let _: DummyType = try await sut.fetchData(from: "somevalidURL")
        }, throws: { error in
            guard let error = error as? APIClient.Error else {
                return false
            }
            return error == .connectionFailed
        })
    }
    
    @Test("GIVEN some valid URL, some valid data, some response whose status code is not 2xx, WHEN call fetch data, THEN it should throw an invalidResponse error")
    func invalidResponseError() async {
        GIVEN_someValidData()
        GIVEN_someResponse(statusCode: 400)
        
        await #expect(performing: {
            let _: DummyType = try await sut.fetchData(from: "somevalidURL")
        }, throws: { error in
            guard let error = error as? APIClient.Error else {
                return false
            }
            return error == .invalidResponse
        })
    }
    
    func GIVEN_someValidData() {
        sut.downloadedData = try! JSONEncoder().encode(DummyType())
    }
    
    func GIVEN_someResponse(statusCode: Int) {
        let response = HTTPURLResponse(url: URL(string: "some-url")!, statusCode: statusCode, httpVersion: "2.0", headerFields: [:])
        sut.response = response
    }
    
    @Test("GIVEN some valid URL, some valid urlresponse, some invalid data, WHEN call fetch data, THEN it should throw a decodingFailed error")
    func decodingError() async {
        GIVEN_someInvalidData()
        GIVEN_someResponse(statusCode: 200)
        
        await #expect(performing: {
            let _: DummyType = try await sut.fetchData(from: "somevalidURL")
        }, throws: { error in
            guard let error = error as? APIClient.Error else {
                return false
            }
            return error == .decodingFailed
        })
    }
    
    func GIVEN_someInvalidData() {
        sut.downloadedData = Data()
    }
    
    @Test("GIVEN some valid URL, some valid urlresponse, some valid data, WHEN call fetch data, THEN it should return the decoded data")
    func successfullDownload() async throws {
        GIVEN_someValidData()
        GIVEN_someResponse(statusCode: 200)
        
        let _: DummyType = try await sut.fetchData(from: "somevalidURL")
    }
}
