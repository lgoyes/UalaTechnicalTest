//
//  DefaultFilterCitiesUseCaseTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class DefaultFilterCitiesUseCaseTests {
    private var sut = DefaultFilterCitiesUseCase()
    private var cities: [CityViewModel]!
    
    @Test("GIVEN cities not set, WHEN execute, THEN throw an inputNotSet error")
    func inputNotSetError() async throws {
        await #expect(throws: FilterCitiesUseCaseError.inputNotSet) {
            try await sut.execute()
        }
    }
    
    @Test("GIVEN some cities, favoritesOnly set to false and searchText empty, WHEN execute, THEN it should return the same cities")
    func filterReturningTheSameCities() async throws {
        GIVEN_someCities()
        
        sut.set(searchText: "")
        sut.set(favoritesOnly: false)
        
        try await sut.execute()
        
        let result = try sut.getResult()
        #expect(result == cities)
    }
    
    @Test("GIVEN some cities, favoritesOnly set to true and searchText empty, WHEN execute, THEN it should return only those cities marked as favorites")
    func filterReturningTheFavoriteCities() async throws {
        GIVEN_someCities()
        
        sut.set(searchText: "")
        sut.set(favoritesOnly: true)
        
        try await sut.execute()
        
        let result = try sut.getResult()
        #expect(!result.contains(where: { $0.favorite == false }))
    }
    
    private func GIVEN_someCities() {
        cities = [
            CityViewModel(id:1, title: "AAA", subtitle: "AAA", favorite: false),
            CityViewModel(id:2, title: "BBB", subtitle: "BBB", favorite: true),
            CityViewModel(id:3, title: "ABB", subtitle: "ABB", favorite: true),
        ]
        sut.set(cities: cities)
    }
    
    @Test("GIVEN some cities, favoritesOnly set to true and searchText NOT empty, WHEN execute, THEN it should return only those cities marked as favorites and mathching the searchText")
    func filterReturningTheFavoriteCitiesPrefixedByB() async throws {
        GIVEN_someCities()
        
        sut.set(searchText: "B")
        sut.set(favoritesOnly: true)
        
        try await sut.execute()
        
        let result = try sut.getResult()
        #expect(result.count == 1)
        #expect(result[0] == cities[1])
    }
}
