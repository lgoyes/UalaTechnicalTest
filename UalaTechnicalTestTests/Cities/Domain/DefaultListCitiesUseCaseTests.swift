//
//  DefaultListCitiesUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

final class CityListRemoteRepositoryStub: CityListRemoteRepository {
    var error: CityListRemoteRepositoryError?
    var result: [City] = []
    func listAllCities() async throws(CityListRemoteRepositoryError) -> [City] {
        if let error {
            throw error
        }
        return result
    }
}

final class DefaultListCitiesUseCaseTests {
    
    private let sut: DefaultListCitiesUseCase
    private let remoteRepository: CityListRemoteRepositoryStub
    private let localRepository: LocalRepositoryStub
    
    init() {
        remoteRepository = .init()
        localRepository = .init()
        sut = DefaultListCitiesUseCase(remoteRepository: remoteRepository, localRepository: localRepository)
    }
    
    @Test("GIVEN some unordered entries, WHEN execute, THEN it should return them sorted alphabetically")
    func displayInAlphabeticalOrder() async throws {
        GIVEN_someUnorderedEntries()
        try await WHEN_execute()
        try THEN_itShouldReturnEntriesSorted()
    }
    
    func GIVEN_someUnorderedEntries() {
        let bogota = CityFactory.create(name: "Bogota", id: 1)
        let medellin = CityFactory.create(name: "Medellin", id: 2)
        let cali = CityFactory.create(name: "Cali", id: 3)
        let armenia = CityFactory.create(name: "Armenia", id: 4)
        
        remoteRepository.result = [ bogota, medellin, cali, armenia ]
    }
    
    func THEN_itShouldReturnEntriesSorted() throws {
        let result = try sut.getResult()
        #expect(remoteRepository.result.sorted(by: { $0.name < $1.name }) == result)
    }
    
    @Test("GIVEN some successful result from the remote repository and no favorite entries, WHEN execute, THEN it should return whatever the remote repository brought back")
    func fetchCorrectResults() async throws {
        GIVEN_noFavoriteEntries()
        try await WHEN_execute()
        try THEN_itShouldReturnWhateverTheRemoteRepositoryBroughtBack()
    }
    
    func GIVEN_noFavoriteEntries() {
        localRepository.result = []
    }
    
    func WHEN_execute() async throws {
        try await sut.execute()
    }
    
    func THEN_itShouldReturnWhateverTheRemoteRepositoryBroughtBack() throws {
        let result = try sut.getResult()
        #expect(result == remoteRepository.result)
    }
    
    @Test("GIVEN some successful result from the remote repository and some favorite entries, WHEN execute, THEN it should modify the remote entries, merging the favorites from the local repository")
    func markFavorites() async throws {
        GIVEN_someSuccessfulResponseFromRemoteRepository()
        GIVEN_someFavoriteEntries()
        try await WHEN_execute()
        try THEN_itShouldModifyTheRemoteEntriesMergingTheLocalFavorites()
    }
    
    func GIVEN_someSuccessfulResponseFromRemoteRepository() {
        remoteRepository.result = [ CityFactory.create(id: 1, favorite: false), CityFactory.create(id: 2)]
    }
    
    func GIVEN_someFavoriteEntries() {
        localRepository.result = [CityFactory.create(id: 1, favorite: true)]
    }
    
    func THEN_itShouldModifyTheRemoteEntriesMergingTheLocalFavorites() throws {
        let result = try sut.getResult()
        #expect(result[0] != remoteRepository.result[0])
        #expect(result[0] == localRepository.result[0])
    }
    
    @Test("GIVEN some error from the remote repository, WHEN execute, THEN it should throw an error")
    func errorFetchingResults() async {
        remoteRepository.error = .networkError
        await #expect(throws: ListCitiesUseCaseError.networkError) {
            try await sut.execute()
        }
    }
}

class DefaultListCitiesUseCaseIntegrationTests {
    
    let context: ModelContext
    let sut: DefaultListCitiesUseCase
    let logger: DefaultLogger
    var logMessages: [String]
    
    init() {
        context = ModelContextStubFactory().create()
        logger = DefaultLogger()
        logMessages = []
        sut = ListCitiesUseCaseFactory(context: context, logger: self.logger).create() as! DefaultListCitiesUseCase
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
    
    @Test("GIVEN some remote repository and no favorite entries, WHEN execute, THEN it should fetch results", .disabled())
    func fetchActualResults() async throws {
        try await WHEN_execute()
        try THEN_itShouldReturnTheEntriesAsTheFetched()
    }
    
    func WHEN_execute() async throws {
        try await sut.execute()
    }
    
    func THEN_itShouldReturnTheEntriesAsTheFetched() throws {
        let result = try sut.getResult()
        #expect(result.count == 209557)
    }
}
