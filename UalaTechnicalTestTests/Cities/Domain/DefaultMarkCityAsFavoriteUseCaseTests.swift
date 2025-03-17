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
        await THEN_itShouldAddTheCityToFavoriteList()
    }
    
    private func GIVEN_someNewFavoriteCityWhichIsNotInTheFavoritesList() {
        localRepository.result = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 10)
        self.sut.set(newFavorite: someCity)
    }
    private func WHEN_execute() async throws {
        try await self.sut.execute()
    }
    @MainActor
    private func THEN_itShouldAddTheCityToFavoriteList() async {
        #expect(try! self.localRepository.listAllCities().count == 3)
        #expect(try! self.localRepository.listAllCities()[2] == someCity)
    }
    
    @Test("GIVEN no new favorite city, WHEN execute, THEN it should throw an error")
    func newFavoriteNotSetError() async {
        await #expect(throws: MarkCityAsFavoriteUseCaseError.newFavoriteNotSet ) {
            try await self.sut.execute()
        }
    }
    
    @Test("GIVEN some new favorite city which is already in the favorites list, WHEN execute, THEN it should not add that entry to the database")
    func doNotAddEntry() async throws {
        GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList()
        await #expect(throws: MarkCityAsFavoriteUseCaseError.favoriteAlreadyExists ) {
            try await self.sut.execute()
        }
        await THEN_itShouldNotAddTheCityToFavoriteList()
    }
    
    private func GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList() {
        localRepository.result = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 1)
        self.sut.set(newFavorite: someCity)
    }
    
    @MainActor
    private func THEN_itShouldNotAddTheCityToFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 2)
    }
}

// TODO: - Poner prueba con el repositorio SIN la base de datos
final class DefaultMarkCityAsFavoriteUseCaseIntegrationTests {
    
}
