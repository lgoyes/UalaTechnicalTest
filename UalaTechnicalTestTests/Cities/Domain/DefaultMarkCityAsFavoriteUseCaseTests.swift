//
//  DefaultMarkCityAsFavoriteUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class DefaultMarkCityAsFavoriteUseCaseTests {
    private let sut: DefaultMarkCityAsFavoriteUseCase
    private let localRepository: LocalRepositoryStub
    private var someCity: City!
    
    init() {
        self.localRepository = LocalRepositoryStub()
        self.sut = DefaultMarkCityAsFavoriteUseCase(localRepository: localRepository)
    }
    
    @Test("GIVEN some new favorite city (which is not in the favorite list), WHEN execute, THEN it should add the city to favorite list")
    func execute() async throws {
        GIVEN_someNewFavoriteCityWhichIsNotInTheFavoritesList()
        try await WHEN_execute()
        THEN_itShouldAddTheCityToFavoriteList()
    }
    
    private func GIVEN_someNewFavoriteCityWhichIsNotInTheFavoritesList() {
        localRepository.cities = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 10)
        self.sut.set(newFavorite: someCity)
    }
    private func WHEN_execute() async throws {
        try await self.sut.execute()
    }
    private func THEN_itShouldAddTheCityToFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 3)
        #expect(try! self.localRepository.listAllCities()[2] == someCity)
    }
    
    @Test("GIVEN no new favorite city, WHEN execute, THEN it should throw an error")
    func newFavoriteNotSetError() async {
        await #expect(throws: MarkCityAsFavoriteUseCaseError.newFavoriteNotSet ) {
            try await self.sut.execute()
        }
    }
    
    @Test("GIVEN some new favorite city and repository throwing some error, WHEN execute, THEN it should throw an error")
    func errorReadingDB() async {
        GIVEN_someNewFavoriteCityWhichIsNotInTheFavoritesList()
        GIVEN_repositoryThrowingSomeError()
        await #expect(throws: MarkCityAsFavoriteUseCaseError.errorReadingDB ) {
            try await self.sut.execute()
        }
    }
    
    private func GIVEN_repositoryThrowingSomeError() {
        localRepository.error = .couldNotListEntries
    }
    
    @Test("GIVEN some new favorite city which is already in the favorites list, WHEN execute, THEN it should not add that entry to the database")
    func doNotAddEntry() async throws {
        GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList()
        try await self.sut.execute()
        THEN_itShouldNotAddTheCityToFavoriteList()
    }
    
    private func GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList() {
        localRepository.cities = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 1)
        self.sut.set(newFavorite: someCity)
    }
    
    private func THEN_itShouldNotAddTheCityToFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 2)
    }
}
