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
    private var delayed_WHEN_remove_closure: (() throws -> Void)?
    private var delayed_WHEN_list_closure: (() throws -> [City])?
    private var delayed_WHEN_update_closure: (() throws -> Void)?
    
    init() {
        self.db = DBFacadeStub()
        self.sut = DefaultCityLocalRepository(db: db, mapper: DBCityMapper())
    }
}

// MARK: - Create
extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some city, WHEN create, THEN it should add city to DB")
    func create() {
        GIVEN_someValidCity()
        WHEN_create()
        THEN_itShouldAddCityToDB()
    }
    
    func GIVEN_someValidCity() {
        city = CityFactory.create()
        db.cities = [DBCityMapper().invert(city)]
    }
    
    func WHEN_create() {
        sut.create(city: city)
    }
    
    func THEN_itShouldAddCityToDB() {
        #expect(db.createCalled)
    }
}

// MARK: - Remove
extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some valid city, WHEN remove, THEN it should remove entry from db and it should not throw any error")
    func remove() {
        GIVEN_someValidCity()
        WHEN_remove()
        THEN_itShouldNotThrowAnyError()
        THEN_itShouldRemoveEntryFromDB()
    }
        
    func WHEN_remove() {
        delayed_WHEN_remove_closure = { [unowned self] in
            try sut.remove(city: city)
        }
    }
    
    func THEN_itShouldNotThrowAnyError() {
        #expect(throws: Never.self) {
            try delayed_WHEN_remove_closure!()
        }
    }
    
    func THEN_itShouldRemoveEntryFromDB() {
        #expect(db.removeCalled)
    }
    
    @Test("GIVEN some invalid city, WHEN remove, THEN it should throw an error and should not invoke remove on db")
    func failedRemove() {
        GIVEN_someInvalidCity()
        WHEN_remove()
        THEN_itShouldThrowACityNotFoundError()
        THEN_itShouldNotInvokeRemoveOnDB()
    }
    
    func GIVEN_someInvalidCity() {
        city = CityFactory.create()
        let anotherCity = City(country: "", name: "", id: city.id + 1, favorite: false, coordinates: Coordinate(latitude: 0, longitude: 0))
        db.cities = [DBCityMapper().invert(anotherCity)]
    }
    
    func THEN_itShouldNotInvokeRemoveOnDB() {
        #expect(db.removeCalled == false)
    }
    
    func THEN_itShouldThrowACityNotFoundError() {
        #expect(throws: CityRemoveLocalRepositoryError.cityNotFoundInDB) {
            try delayed_WHEN_remove_closure!()
        }
    }
}

// MARK: - Update
extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some valid city, WHEN update, THEN it should update entry from db and it should not throw any error")
    func update() {
        GIVEN_someCitiesInDB()
        GIVEN_someUpdatedCity()
        WHEN_update()
        THEN_itShouldNotThrowAnyUpdateError()
        THEN_itShouldUpdateEntryFromDB()
    }
    
    func GIVEN_someUpdatedCity() {
        city = City(country: Constant.updatedCountry, name: CityConstant.someName, id: CityConstant.someId, favorite: CityConstant.favorite, coordinates: CoordinateFactory.createSomeCoordinates())
    }
        
    func WHEN_update() {
        delayed_WHEN_update_closure = { [unowned self] in
            try sut.update(city: city)
        }
    }
    
    func THEN_itShouldNotThrowAnyUpdateError() {
        #expect(throws: Never.self) {
            try delayed_WHEN_update_closure!()
        }
    }
    
    func THEN_itShouldUpdateEntryFromDB() {
        #expect(db.cities[0].country == Constant.updatedCountry)
    }
    
    @Test("GIVEN some invalid city, WHEN update, THEN it should throw an error")
    func failedUpdate() {
        GIVEN_someCitiesInDB()
        GIVEN_someInvalidCity()
        WHEN_update()
        THEN_itShouldThrowACityNotFoundUpdateError()
    }
    
    func THEN_itShouldThrowACityNotFoundUpdateError() {
        #expect(throws: CityUpdateLocalRepositoryError.cityNotFoundInDB) {
            try delayed_WHEN_update_closure!()
        }
    }
}

// MARK: - List

extension DefaultCityLocalRepositoryTests {
    @Test("GIVEN some cities, WHEN list, THEN it should return the cities from the DB")
    func list() {
        GIVEN_someCitiesInDB()
        WHEN_list()
        THEN_itShouldNotThrowAnyListError()
        THEN_itShouldReturnEntriesFromDB()
    }
    
    func GIVEN_someCitiesInDB() {
        db.cities = [DBCityMapper().invert(CityFactory.create())]
    }
        
    func WHEN_list() {
        delayed_WHEN_list_closure = { [unowned self] in
            try sut.listAllCities()
        }
    }
    
    func THEN_itShouldNotThrowAnyListError() {
        #expect(throws: Never.self) {
            cities = try delayed_WHEN_list_closure!()
        }
    }
    
    func THEN_itShouldReturnEntriesFromDB() {
        #expect(cities != nil)
        #expect(cities.count == 1)
    }
    
    @Test("GIVEN db listing entries with some error, WHEN list, THEN it should throw an error")
    func failedList() {
        GIVEN_errorWhenDBListsEntries()
        WHEN_list()
        THEN_itShouldThrowAListError()
    }
    
    func GIVEN_errorWhenDBListsEntries() {
        db.error = .listingFailed
    }
    
    func THEN_itShouldThrowAListError() {
        #expect(throws: CityListLocalRepositoryError.couldNotListEntries) {
            cities = try delayed_WHEN_list_closure!()
        }
    }
}
