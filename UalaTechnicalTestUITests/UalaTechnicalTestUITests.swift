//
//  UalaTechnicalTestUITests.swift
//  UalaTechnicalTestUITests
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import XCTest

final class UalaTechnicalTestUITests: XCTestCase {
    private enum Constant {
        enum OneVisibleRowAfterSearch {
            static let name = "Medellin, CO"
        }
        enum OneVisibleRowInFirstPage {
            static let name = "665 Site Colonia, US"
        }
        enum OneVisibleRowInTheThirdPage {
            static let name = "Aalen, DE"
        }
        enum Map {
            static let accessibilityId = "city-map"
        }
        enum SearchBar {
            static let prompt = "Search"
        }
        enum Timeout {
            static let short: TimeInterval = 1.0
            static let long: TimeInterval = 20.0
        }
    }

    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func test_openingMapInPortrait() throws {
        XCUIDevice.shared.orientation = .portrait
        
        let someCityRow = app.staticTexts[Constant.OneVisibleRowInFirstPage.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
        
        someCityRow.tap()
        
        let theMap = app.otherElements[Constant.Map.accessibilityId]
        XCTAssertTrue(theMap.waitForExistence(timeout: Constant.Timeout.short))
    }
    
    @MainActor
    func test_swipingUpTheList() throws {
        XCUIDevice.shared.orientation = .portrait
        
        let someCityRow = app.staticTexts[Constant.OneVisibleRowInFirstPage.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
        
        app.swipeUp()
        app.swipeUp()
        
        let anotherCityRow = app.staticTexts[Constant.OneVisibleRowInTheThirdPage.name]
        XCTAssertTrue(anotherCityRow.waitForExistence(timeout: Constant.Timeout.long))
    }
    
    @MainActor
    func test_mapShouldNotBeVisibleInPortraitModeAtFirstGlance() throws {
        XCUIDevice.shared.orientation = .portrait
        
        let someCityRow = app.staticTexts[Constant.OneVisibleRowInFirstPage.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
        
        let theMap = app.otherElements[Constant.Map.accessibilityId]
        XCTAssertTrue(!theMap.exists)
    }
    
    @MainActor
    func test_mapShouldNotBeVisibleInLandscapeModeAtFirstGlance() throws {
        XCUIDevice.shared.orientation = .landscapeRight

        let someCityRow = app.staticTexts[Constant.OneVisibleRowInFirstPage.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
        
        let theMap = app.otherElements[Constant.Map.accessibilityId]
        XCTAssertTrue(!theMap.exists)
    }
    
    
    @MainActor
    func test_mapShouldBeVisibleInLandscapeModeAfterTappingOnOneCity() throws {
        XCUIDevice.shared.orientation = .landscapeRight

        let someCityRow = app.staticTexts[Constant.OneVisibleRowInFirstPage.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
        
        someCityRow.tap()
        
        let theMap = app.otherElements[Constant.Map.accessibilityId]
        XCTAssertTrue(theMap.exists)
    }
    
    @MainActor
    func test_searchForMedellin() throws {
        XCUIDevice.shared.orientation = .portrait
        
        let searchBar = app.searchFields.firstMatch
        XCTAssertTrue(searchBar.waitForExistence(timeout: Constant.Timeout.long))
        
        searchBar.tap()
        
        searchBar.typeText(Constant.OneVisibleRowAfterSearch.name)
        let someCityRow = app.staticTexts[Constant.OneVisibleRowAfterSearch.name]
        XCTAssertTrue(someCityRow.waitForExistence(timeout: Constant.Timeout.long))
    }
}
