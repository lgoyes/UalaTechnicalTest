//
//  DefaultCityLocalRepositoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class DBFacadeStub: DBFacade {
    var createCalled = false
    var removeCalled = false
    var cities = [DBCity]()
    var error: DBCityListableError?
    
    func create(city: DBCity) {
        createCalled = true
    }
    func remove(city: DBCity) {
        removeCalled = true
    }
    func listAllCities() throws(DBCityListableError) -> [DBCity] {
        if let error {
            throw error
        }
        return cities
    }
}

final class DefaultCityLocalRepositoryTests {
    private enum Constant {
        static let updatedCountry = "updated-country"
    }
    private var sut: DefaultCityLocalRepository
    private var city: City!
    private var cities: [City]!
    private var db: DBFacadeStub
    private var delayed_WHEN_remove_closure: (() async throws -> Void)?
    private var delayed_WHEN_list_closure: (() async throws -> [City])?
    
    init() {
        self.db = DBFacadeStub()
        self.sut = DefaultCityLocalRepository(db: db, mapper: DBCityMapper())
    }
}

// MARK: - Create
extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some city non existing in DB, WHEN create, THEN it should add city to DB")
    func create() async throws {
        GIVEN_someCityThatDoesNotExistInDB()
        try await WHEN_create()
        THEN_itShouldAddCityToDB()
    }
    
    func GIVEN_someCityThatDoesNotExistInDB() {
        city = CityFactory.create(id: 1)
        db.cities = [DBCityMapper().invert(CityFactory.create(id: 2))]
    }
    
    func WHEN_create() async throws {
        try await sut.create(city: city)
    }
    
    func THEN_itShouldAddCityToDB() {
        #expect(db.createCalled)
    }
}

// MARK: - Remove
extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some city that exists in db, WHEN remove, THEN it should remove entry from db and it should not throw any error")
    func remove() async {
        GIVEN_someCityThatExistsInDB()
        WHEN_remove()
        await THEN_itShouldNotThrowAnyError()
        THEN_itShouldRemoveEntryFromDB()
    }
    
    func GIVEN_someCityThatExistsInDB() {
        city = CityFactory.create(id: 1)
        db.cities = [DBCityMapper().invert(CityFactory.create(id: 1))]
    }
        
    func WHEN_remove() {
        delayed_WHEN_remove_closure = { [unowned self] in
            try await sut.remove(city: city)
        }
    }
    
    func THEN_itShouldNotThrowAnyError() async {
        await #expect(throws: Never.self) {
            try await delayed_WHEN_remove_closure!()
        }
    }
    
    func THEN_itShouldRemoveEntryFromDB() {
        #expect(db.removeCalled)
    }
    
    @Test("GIVEN some city that does not exist in db, WHEN remove, THEN it should throw an error and should not invoke remove on db")
    func failedRemove() async {
        GIVEN_someCityThatDoesNotExistInDB()
        WHEN_remove()
        await THEN_itShouldThrowACityNotFoundError()
        THEN_itShouldNotInvokeRemoveOnDB()
    }
    
    func THEN_itShouldNotInvokeRemoveOnDB() {
        #expect(db.removeCalled == false)
    }
    
    func THEN_itShouldThrowACityNotFoundError() async {
        await #expect(throws: CityRemoveLocalRepositoryError.cityNotFoundInDB) {
            try await delayed_WHEN_remove_closure!()
        }
    }
}

// MARK: - List

extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some cities, WHEN list, THEN it should return the cities from the DB")
    func list() async {
        GIVEN_someCitiesInDB()
        WHEN_list()
        await THEN_itShouldNotThrowAnyListError()
        THEN_itShouldReturnEntriesFromDB()
    }
    
    func GIVEN_someCitiesInDB() {
        db.cities = [DBCityMapper().invert(CityFactory.create())]
    }
        
    func WHEN_list() {
        delayed_WHEN_list_closure = { [unowned self] in
            try await sut.listAllCities()
        }
    }
    
    func THEN_itShouldNotThrowAnyListError() async {
        await #expect(throws: Never.self) {
            cities = try await delayed_WHEN_list_closure!()
        }
    }
    
    func THEN_itShouldReturnEntriesFromDB() {
        #expect(cities != nil)
        #expect(cities.count == 1)
    }
    
    @Test("GIVEN db listing entries with some error, WHEN list, THEN it should throw an error")
    func failedList() async {
        GIVEN_errorWhenDBListsEntries()
        WHEN_list()
        await THEN_itShouldThrowAListError()
    }
    
    func GIVEN_errorWhenDBListsEntries() {
        db.error = .listingFailed
    }
    
    func THEN_itShouldThrowAListError() async {
        await #expect(throws: CityListLocalRepositoryError.couldNotListEntries) {
            cities = try await delayed_WHEN_list_closure!()
        }
    }
}
