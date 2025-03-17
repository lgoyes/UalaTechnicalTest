//
//  DefaultToggleFavoriteUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class DefaultToggleFavoriteUseCaseTests {
    private let sut: DefaultToggleFavoriteUseCase
    private let localRepository: LocalRepositoryStub
    private var someCityId: Int!
    
    init() {
        self.localRepository = LocalRepositoryStub()
        self.sut = DefaultToggleFavoriteUseCase(localRepository: localRepository)
    }
    
    @Test("GIVEN no reference cities, WHEN execute, THEN it should throw a missingRawCities error")
    func missingRawCitiesError() async throws {
        GIVEN_noReferenceCities()
        await #expect(throws: ToggleFavoriteUseCaseError.missingRawCities) {
            try await sut.execute()
        }
    }
    private func GIVEN_noReferenceCities() {
        // do nothing on sut
    }
    
    
    @Test("GIVEN no candidate city and some reference cities, WHEN execute, THEN it should throw a missingFavoriteCandidate error")
    func missingFavoriteCandidateError() async throws {
        GIVEN_someReferenceCities()
        await #expect(throws: ToggleFavoriteUseCaseError.missingFavoriteCandidate) {
            try await sut.execute()
        }
    }
    private func GIVEN_someReferenceCities(entry: City = CityFactory.create(id: 1)) {
        self.sut.set(rawCities: [entry, CityFactory.create(id:2)])
    }
    
    @Test("GIVEN some reference cities, and some candidate city which is currently marked as favorite, and candidate city is stored in db, WHEN execute, THEN it should remove the city from favorite list")
    func removeSuccess() async throws {
        GIVEN_someReferenceCities(entry: CityFactory.create(id: 1, favorite: true))
        GIVEN_someFavoriteCityWhichIsAlreadyInTheFavoritesList()
        try await WHEN_execute()
        await THEN_itShouldRemoveTheCityFromFavoriteList()
    }
    
    private func GIVEN_someFavoriteCityWhichIsAlreadyInTheFavoritesList() {
        localRepository.result = [CityFactory.create(id: 1, favorite: true), CityFactory.create(id:2)]
        someCityId = 1
        self.sut.set(favoriteCandidateId: someCityId)
    }
    
    private func WHEN_execute() async throws {
        try await self.sut.execute()
    }
    
    @MainActor
    private func THEN_itShouldRemoveTheCityFromFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 1)
        #expect(try! self.localRepository.listAllCities()[0].id == 2)
    }
    
    @Test("GIVEN some reference cities, and some candidate city which is currently marked as NOT favorite, and candidate city is NOT stored in db, WHEN execute, THEN it should add the city to favorite list")
    func addingSuccess() async throws {
        GIVEN_someReferenceCities(entry: CityFactory.create(id: 1, favorite: false))
        GIVEN_someFavoriteCityWhichIsNOTInTheFavoritesList()
        try await WHEN_execute()
        await THEN_itShouldAddTheCityToFavoriteList()
    }
    
    private func GIVEN_someFavoriteCityWhichIsNOTInTheFavoritesList() {
        localRepository.result = [CityFactory.create(id:2)]
        someCityId = 1
        self.sut.set(favoriteCandidateId: someCityId)
    }
    
    @MainActor
    private func THEN_itShouldAddTheCityToFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 2)
        #expect(try! self.localRepository.listAllCities()[1].id == 1)
    }
    
    @Test("GIVEN some reference cities, and some candidate city which is currently marked as NOT favorite, and candidate city is already stored in db, WHEN execute, THEN it should throw an error favoriteAlreadyExists")
    func additionError() async throws {
        GIVEN_someReferenceCities(entry: CityFactory.create(id: 1, favorite: false))
        GIVEN_someFavoriteCityWhichIsAlreadyInTheFavoritesList()
        await #expect(throws: ToggleFavoriteUseCaseError.favoriteAlreadyExists) {
            try await sut.execute()
        }
    }
    
    @Test("GIVEN some reference cities, and some candidate city which is currently marked as favorite, and candidate city is NOT stored in db, WHEN execute, THEN it should throw an error favoriteNotFound")
    func remotionError() async throws {
        GIVEN_someReferenceCities(entry: CityFactory.create(id: 1, favorite: true))
        GIVEN_someFavoriteCityWhichIsNOTInTheFavoritesList()
        await #expect(throws: ToggleFavoriteUseCaseError.favoriteNotFound) {
            try await sut.execute()
        }
    }
    
}
