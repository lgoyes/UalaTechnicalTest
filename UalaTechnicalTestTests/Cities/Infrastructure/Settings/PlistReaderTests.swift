//
//  PlistReaderTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation
import Testing
@testable import UalaTechnicalTest

final class PlistReaderTests {

    private let sut = PlistReader()
    
    private var bundle: Bundle!
    private var plistFilename: String!
    private var plistFile: [String: Any]?
    
    @Test("GIVEN some valid bundle, some existing plist filename, WHEN trying to load plist, THEN it should return the loaded plist")
    func readSomePlistFile() throws {
        GIVEN_someValidBundle()
        GIVEN_someExistingPlistFilename()
        try WHEN_tryingToLoadPlist()
        THEN_itShouldReturnTheLoadedPlist()
    }
    
    func GIVEN_someValidBundle() {
        bundle = Bundle(for: type(of: self))
    }
    
    func GIVEN_someExistingPlistFilename() {
        plistFilename = "DummyPlist"
    }
    
    func WHEN_tryingToLoadPlist() throws {
        plistFile = try #require( sut.loadPlist(filename: plistFilename, bundle: bundle) )
    }
    
    func THEN_itShouldReturnTheLoadedPlist() {
        #expect(plistFile!["entry"] as! String == "something")
    }
    
    @Test("GIVEN some valid bundle, some non-existing plist filename, WHEN trying to load plist, THEN it should return nil")
    func tryingToReadNonexistingPlistFile() {
        GIVEN_someValidBundle()
        GIVEN_someNonExistingPlistFilename()
        
        let plistFile = sut.loadPlist(filename: plistFilename, bundle: bundle)
        #expect(plistFile == nil)
    }
    
    func GIVEN_someNonExistingPlistFilename() {
        plistFilename = "AnotherPlist"
    }
}
