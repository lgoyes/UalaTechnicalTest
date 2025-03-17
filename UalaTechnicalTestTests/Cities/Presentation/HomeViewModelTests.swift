//
//  HomeViewModelTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import Testing
import XCTest
import Combine
@testable import UalaTechnicalTest

fileprivate class ListCitiesUseCaseStub: ListCitiesUseCase {
    var result: [City] = []
    var error: ListCitiesUseCaseError?
    
    func execute() async throws(UalaTechnicalTest.ListCitiesUseCaseError) {
        
    }
    
    func getResult() throws(UalaTechnicalTest.ListCitiesUseCaseError) -> Array<UalaTechnicalTest.City> {
        if let error {
            throw error
        }
        return result
    }
}

fileprivate class FilterCitiesUseCaseStub: FilterCitiesUseCase {
    var result: [CityViewModel] = []
    var error: FilterCitiesUseCaseError?
    
    var favoritesOnly: Bool?
    var searchText: String?
    
    func set(cities: [UalaTechnicalTest.CityViewModel]) {}
    func set(favoritesOnly: Bool) {
        self.favoritesOnly = favoritesOnly
    }
    func set(searchText: String) {
        self.searchText = searchText
    }
    
    func execute() async throws(UalaTechnicalTest.FilterCitiesUseCaseError) {
        
    }
    
    func getResult() throws(UalaTechnicalTest.FilterCitiesUseCaseError) -> Array<UalaTechnicalTest.CityViewModel> {
        if let error {
            throw error
        }
        return result.filter { if favoritesOnly == true { return $0.favorite } else { return true } }
    }
}

fileprivate class ToggleFavoriteUseCaseStub: ToggleFavoriteUseCase {
    var result: [City] = []
    var error: ToggleFavoriteUseCaseError?
    var favoriteCandidateId: Int?
    
    func set(rawCities: [City]) {}
    func set(favoriteCandidateId: Int) {
        self.favoriteCandidateId = favoriteCandidateId
    }
    
    func execute() async throws(UalaTechnicalTest.ToggleFavoriteUseCaseError) {
        
    }
    
    func getResult() throws(UalaTechnicalTest.ToggleFavoriteUseCaseError) -> Array<UalaTechnicalTest.City> {
        if let error {
            throw error
        }
        return result
    }
}

final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var listCities: ListCitiesUseCaseStub!
    private var filter: FilterCitiesUseCaseStub!
    private var toggle: ToggleFavoriteUseCaseStub!
    private var cancellables: Set<AnyCancellable> = []
    private var searchText = ""
    private var favoritesOnly = true
    
    override func setUp() {
        super.setUp()
        self.listCities = ListCitiesUseCaseStub()
        self.filter = FilterCitiesUseCaseStub()
        self.toggle = ToggleFavoriteUseCaseStub()
        self.sut = HomeViewModel(listCitiesUseCase: listCities, filterCitiesUseCase: filter, toggleFavoriteUseCase: toggle)
    }
    
    override func tearDown() {
        self.listCities = nil
        self.filter = nil
        self.toggle = nil
        self.sut = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // GIVEN listcities returning some cities, WHEN processOnAppear, THEN it should download data and present it
    func test_processOnAppear() {
        GIVEN_someFavoritesOnlySetToFalse()
        GIVEN_someSearchText()
        GIVEN_listCitiesReturningSomeCities()
        GIVEN_filterReturningSomeCities()
        
        let expectation = XCTestExpectation(description: "Cities changed")
        
        sut.$filteredCities
                    .sink(receiveCompletion: { _ in }, receiveValue: { value in
                        if !value.isEmpty {
                            XCTAssertEqual(value.count, 2)
                            XCTAssertEqual(value[0].title, "Medellín, CO")
                            expectation.fulfill()
                        }
                    })
                    .store(in: &cancellables)
        
        sut.processOnAppear()
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(searchText, filter.searchText)
        XCTAssertEqual(favoritesOnly, filter.favoritesOnly)
    }
    
    private func GIVEN_someSearchText() {
        searchText = "ABC"
        sut.searchText = searchText
    }
    
    private func GIVEN_someFavoritesOnlySetToFalse() {
        favoritesOnly = false
        sut.showFavoritesOnly = favoritesOnly
    }
    
    private func GIVEN_listCitiesReturningSomeCities() {
        listCities.result = [
            City(country: "CO", name: "Medellin", id: 1, favorite: false, coordinates: Coordinate(latitude: 1, longitude: 1)),
            City(country: "CO", name: "Bogota", id: 2, favorite: true, coordinates: Coordinate(latitude: 1, longitude: 1)),
            City(country: "CO", name: "Pasto", id: 3, favorite: false, coordinates: Coordinate(latitude: 1, longitude: 1))
        ]
    }
    
    private func GIVEN_filterReturningSomeCities() {
        filter.result = [
            CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false),
            CityViewModel(id: 2, title: "Bogota, CO", subtitle: "Lat: 1, Lon: 2", favorite: true)
        ]
    }
}
