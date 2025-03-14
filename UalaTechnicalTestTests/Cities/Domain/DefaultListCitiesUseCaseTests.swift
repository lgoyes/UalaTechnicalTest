//
//  DefaultListCitiesUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
@testable import UalaTechnicalTest

class CityListRemoteRepositoryStub: CityListRemoteRepository {
    var error: CityListRemoteRepositoryError?
    var result: [City] = [CityFactory.createSomeCity()]
    func listAllCities() async throws(CityListRemoteRepositoryError) -> [City] {
        if let error {
            throw error
        }
        return result
    }
}

class DefaultListCitiesUseCaseTests {
    
    let sut: DefaultListCitiesUseCase
    let repository: CityListRemoteRepositoryStub
    init() {
        repository = .init()
        sut = DefaultListCitiesUseCase(repository: repository)
    }
    
    @Test("GIVEN some successful result from repository, WHEN execute, THEN it should return whatever the repository brought back")
    func fetchCorrectResults() async throws {
        try await sut.execute()
        let result = try sut.getResult()
        #expect(result == [CityFactory.createSomeCity()])
    }
    
    @Test("GIVEN some error from the repository, WHEN execute, THEN it should throw an error")
    func errorFetchingResults() async {
        repository.error = .networkError
        await #expect(throws: ListCitiesUseCaseError.networkError) {
            try await sut.execute()
        }
    }
}

class DefaultListCitiesUseCaseIntegrationTests {
    
    let sut: DefaultListCitiesUseCase
    let logger: DefaultLogger
    var logMessages: [String]
    
    init() {
        logger = DefaultLogger()
        logMessages = []
        sut = ListCitiesUseCaseFactory(logger: self.logger).create() as! DefaultListCitiesUseCase
    }
    
    // I had an error while testing this feature. I leave this test just to show my way of approaching the problem and how did I found what the error was.
    @Test("GIVEN some logger, WHEN execute, THEN the request should fail and it should log some messages", .disabled())
    func failedFetch() async {
        GIVEN_someLogger()
        try? await sut.execute()
        
        let expectedErrorMessage = "There was an error decoding the response: [\"NSCodingPath\": [_CodingKey(stringValue: \"Index 0\", intValue: 0)], \"NSDebugDescription\": \"No value associated with key CodingKeys(stringValue: \\\"coor\\\", intValue: nil) (\\\"coor\\\").\"]"
        #expect(logMessages[0] == expectedErrorMessage)
    }
    
    func GIVEN_someLogger() {
        logger.registerHandler(for: .error) { [unowned self] in
            self.logMessages.append($0)
        }
    }
    
    @Test("GIVEN some repository, WHEN execute, THEN it should fetch results")
    func fetchResults() async throws {
        try await sut.execute()
        let result = try sut.getResult()
        #expect(result.count > 0)
    }
}
