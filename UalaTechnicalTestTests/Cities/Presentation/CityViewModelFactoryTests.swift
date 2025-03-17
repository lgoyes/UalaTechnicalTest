//
//  CityViewModelFactoryTests.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import Testing
@testable import UalaTechnicalTest

final class CityViewModelFactoryTests {
    private var city: City!
    private var cityViewModel: CityViewModel!
    private var sut = CityViewModelFactory()
    private var result: CityViewModel!
    
    @Test
    func basicTest() {
        GIVEN_someCity()
        WHEN_create()
        THEN_itShouldReturnAValidViewModel()
    }
    
    private func GIVEN_someCity() {
        city = CityFactory.create()
    }
    
    private func WHEN_create() {
        result = sut.create(city: city)
    }
    
    private func THEN_itShouldReturnAValidViewModel() {
        let expectedId = city.id
        let expectedTitle = "Medellín, CO"
        let expectedSubtitle = "Lat: 12.34, Lon: 54.32"
        let expectedFavorite = city.favorite
        let expectedResult = CityViewModel(id: expectedId, title: expectedTitle, subtitle: expectedSubtitle, favorite: expectedFavorite)
        #expect(result == expectedResult)
    }
}
