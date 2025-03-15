//
//  DefaultUnmarkCityAsFavoriteUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class DefaultUnmarkCityAsFavoriteUseCaseTests {
    private let sut: DefaultUnmarkCityAsFavoriteUseCase
    private let localRepository: LocalRepositoryStub
    private var someCity: City!
    
    init() {
        self.localRepository = LocalRepositoryStub()
        self.sut = DefaultUnmarkCityAsFavoriteUseCase(localRepository: localRepository)
    }
    
    @Test("GIVEN some new favorite city (which is already in the favorite list), WHEN execute, THEN it should remove the city from favorite list")
    func execute() async throws {
        GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList()
        try await WHEN_execute()
        THEN_itShouldRemoveTheCityFromFavoriteList()
    }
    
    private func GIVEN_someNewFavoriteCityWhichIsAlreadyInTheFavoritesList() {
        localRepository.cities = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 1)
        self.sut.set(favoriteToRemove: someCity)
    }
    private func WHEN_execute() async throws {
        try await self.sut.execute()
    }
    private func THEN_itShouldRemoveTheCityFromFavoriteList() {
        #expect(try! self.localRepository.listAllCities().count == 1)
        #expect(try! self.localRepository.listAllCities()[0].id == 2)
    }
    
    @Test("GIVEN no favorite city to remove, WHEN execute, THEN it should throw an error")
    func favoriteToRemoveNotSetError() async {
        await #expect(throws: UnmarkCityAsFavoriteUseCaseError.favoriteToRemoveNotSet ) {
            try await self.sut.execute()
        }
    }
    
    @Test("GIVEN some favorite city to remove that does not exist in DB, WHEN execute, THEN it should throw an error")
    func favoriteNotFound() async {
        GIVEN_someFavoriteCityToRemoveWhichIsNotInTheFavoritesList()
        await #expect(throws: UnmarkCityAsFavoriteUseCaseError.favoriteNotFound ) {
            try await self.sut.execute()
        }
    }
    
    private func GIVEN_someFavoriteCityToRemoveWhichIsNotInTheFavoritesList() {
        localRepository.cities = [CityFactory.create(id: 1), CityFactory.create(id:2)]
        someCity = CityFactory.create(id: 10)
        self.sut.set(favoriteToRemove: someCity)
    }
}
