//
//  APIClientTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation
import Testing
@testable import UalaTechnicalTest

final class TestingAPIClient: APIClient {
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

struct DummyType: Codable { }

final class APIClientTests {
    
    private let sut = TestingAPIClient()
    
    private var url: String!
    private var delayed_WHEN_closure: (() async throws -> ())!
    private var decodedData: DummyType!
    
    @Test("GIVEN some invalid URL, WHEN call fetch data, THEN it should throw an invalidURL error")
    func invalidURL() async {
        GIVEN_someInvalidURL()
        WHEN_callingFetchData_delayed()
        await THEN_itShouldThrowAn(error: .badURL)
    }
    
    func GIVEN_someInvalidURL() {
        url = ""
    }
    
    func WHEN_callingFetchData_delayed() {
        delayed_WHEN_closure = { [unowned self] in
            self.decodedData = try await self.sut.fetchData(from: self.url)
        }
    }
    
    func THEN_itShouldThrowAn(error expectedError: RESTAPIFetchableError) async {
        await #expect(throws: expectedError) {
            try await delayed_WHEN_closure()
        }
    }
    
    @Test("GIVEN some valid URL, and a connection error, WHEN call fetch data, THEN it should throw a connectionFailed error")
    func connectionFailed() async {
        GIVEN_someValidURL()
        WHEN_callingFetchData_delayed()
        await THEN_itShouldThrowAn(error: .connectionFailed)
    }
    
    func GIVEN_someValidURL() {
        url = "somevalidurl"
    }
    
    @Test("GIVEN some valid URL, some valid data, some response whose status code is not 2xx, WHEN call fetch data, THEN it should throw an invalidResponse error")
    func invalidResponseError() async {
        GIVEN_someValidURL()
        GIVEN_someValidData()
        GIVEN_someResponse(statusCode: 400)
        WHEN_callingFetchData_delayed()
        await THEN_itShouldThrowAn(error: .invalidResponse)
    }
    
    func GIVEN_someValidData() {
        sut.downloadedData = try! JSONEncoder().encode(DummyType())
    }
    
    func GIVEN_someResponse(statusCode: Int) {
        let response = HTTPURLResponse(url: URL(string: "some-url")!, statusCode: statusCode, httpVersion: "", headerFields: [:])
        sut.response = response
    }
    
    @Test("GIVEN some valid URL, some valid urlresponse, some invalid data, WHEN call fetch data, THEN it should throw a decodingFailed error")
    func decodingError() async {
        GIVEN_someValidURL()
        GIVEN_someInvalidData()
        GIVEN_someResponse(statusCode: 200)
        WHEN_callingFetchData_delayed()
        let error: NSError = NSError(domain: NSCocoaErrorDomain, code: 4864)
        await THEN_itShouldThrowAn(error: .decodingFailed(error))
    }
    
    func GIVEN_someInvalidData() {
        sut.downloadedData = Data()
    }
    
    @Test("GIVEN some valid URL, some valid urlresponse, some valid data, WHEN call fetch data, THEN it should return the decoded data")
    func successfullDownload() async throws {
        GIVEN_someValidURL()
        GIVEN_someValidData()
        GIVEN_someResponse(statusCode: 200)
        try await WHEN_callingFetchData()
        THEN_itShouldReturnTheDecodedData()
    }
    
    func WHEN_callingFetchData() async throws {
        decodedData = try await sut.fetchData(from: url)
    }
    
    func THEN_itShouldReturnTheDecodedData() {
        #expect(decodedData != nil)
    }
}
