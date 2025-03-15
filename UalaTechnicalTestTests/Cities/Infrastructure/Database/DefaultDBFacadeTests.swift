//
//  DefaultDBFacadeTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import Testing
import SwiftData
@testable import UalaTechnicalTest

final class DBCityCreatableStub: DBCityCreatable {
    var createCalled = false
    func create(city: DBCity) {
        createCalled = true
    }
}

final class DBCityRemovableStub: DBCityRemovable {
    var removeCalled = false
    func remove(city: DBCity) {
        removeCalled = true
    }
}

final class DBCityListableStub: DBCityListable {
    var listCalled = false
    func listAllCities() throws(DBCityListableError) -> [DBCity] {
        listCalled = true
        return []
    }
}

final class DefaultDBCityFacadeTests {
    
    private let sut: DefaultDBFacade
    private var someDBCity: DBCity!
    private let creator: DBCityCreatableStub
    private let lister: DBCityListableStub
    private let remover: DBCityRemovableStub
    
    init() throws {
        creator = DBCityCreatableStub()
        lister = DBCityListableStub()
        remover = DBCityRemovableStub()
        sut = DefaultDBFacade(creatable: creator, listable: lister, removable: remover)
    }
    
    @Test("GIVEN some db city, WHEN creating a city, THEN it should delegate task to creator")
    func creating() {
        GIVEN_someDBCity()
        WHEN_creatingACity()
        THEN_itShouldDelegateTaskToCreatorDependency()
    }
    
    func GIVEN_someDBCity() {
        someDBCity = DBCityFactory.create()
    }
    
    func WHEN_creatingACity() {
        sut.create(city: someDBCity)
    }
    
    func THEN_itShouldDelegateTaskToCreatorDependency() {
        #expect(creator.createCalled)
    }
    
    @Test("GIVEN some db city, WHEN removing a city, THEN it should delegate task to remover")
    func removing() {
        GIVEN_someDBCity()
        WHEN_removingACity()
        THEN_itShouldDelegateTaskToRemoverDependency()
    }
    
    func WHEN_removingACity() {
        sut.remove(city: someDBCity)
    }
    
    func THEN_itShouldDelegateTaskToRemoverDependency() {
        #expect(remover.removeCalled)
    }
    
    @Test("WHEN listing, THEN it should delegate task to lister")
    func listing() throws {
        try WHEN_listingCities()
        THEN_itShouldDelegateTaskToListerDependency()
    }
    
    func WHEN_listingCities() throws {
        _ = try sut.listAllCities()
    }
    
    func THEN_itShouldDelegateTaskToListerDependency() {
        #expect(lister.listCalled)
    }
}
