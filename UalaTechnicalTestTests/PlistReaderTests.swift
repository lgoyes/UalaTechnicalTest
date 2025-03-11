//
//  PlistReaderTests.swift
//  UalaTechnicalTestTests
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation
import Testing
@testable import UalaTechnicalTest

class PlistReaderTests {

    let sut = PlistReader()
    
    @Test func readSomePlistFile() throws {
        let thisBundle = Bundle(for: type(of: self))
        let plistFile = try #require( sut.loadPlist(filename: "DummyPlist", bundle: thisBundle) )
        #expect(plistFile["entry"] as! String == "something")
    }

}
