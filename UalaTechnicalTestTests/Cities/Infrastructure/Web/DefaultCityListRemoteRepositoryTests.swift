//
//  DefaultCityListRemoteRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
@testable import UalaTechnicalTest

class APIClientStub: RESTAPIFetchable {
    var response: Decodable!
    var error: RESTAPIFetchableError?
    
    func fetchData<T>(from urlString: String) async throws(RESTAPIFetchableError) -> T where T : Decodable {
        if let error {
            throw error
        }
        return response as! T
    }
}

class DefaultCityListRemoteRepositoryTests {
    
    var sut: DefaultCityListRemoteRepository!
    let clientStub: APIClientStub
    let cityMapper: APICityMapper
    var result: [City]!
    var delayed_listAllCities_closure: (() async throws -> Void)!
    
    init() {
        clientStub = APIClientStub()
        cityMapper = APICityMapper(coordinateMapper: APICoordinateMapper())
        sut = DefaultCityListRemoteRepository(apiClient: clientStub, baseURL: "", cityMapper: cityMapper)
    }
    
    @Test("GIVEN some valid response from APIClient, WHEN listAllCities, THEN it should return some cities")
    func listAllCities() async throws {
        GIVEN_someValidResponseFromAPIClient()
        try await WHEN_listAllCities()
        THEN_itShouldReturnSomeCities()
    }
    
    func GIVEN_someValidResponseFromAPIClient() {
        clientStub.response = [
            APICityFactory.create()
        ]
    }
    
    func WHEN_listAllCities() async throws {
        result = try await sut.listAllCities()
    }
    
    func THEN_itShouldReturnSomeCities() {
        #expect(result[0] == CityFactory.create())
    }
    
    @Test("GIVEN some invalid response from APIClient, WHEN listAllCities, THEN it should throw an error")
    func errorFromAPIClient() async throws {
        GIVEN_someInvalidResponseFromAPIClient()
        WHEN_listAllCities_delayed()
        await THEN_itShouldThrowAnError()
    }
    
    func GIVEN_someInvalidResponseFromAPIClient() {
        clientStub.error = RESTAPIFetchableError.badURL
    }
    
    func WHEN_listAllCities_delayed() {
        delayed_listAllCities_closure = { [unowned self] in
            self.result = try await self.sut.listAllCities()
        }
    }
    
    func THEN_itShouldThrowAnError() async {
        await #expect(throws: CityListRemoteRepositoryError.networkError) {
            try await delayed_listAllCities_closure()
        }
    }
}
