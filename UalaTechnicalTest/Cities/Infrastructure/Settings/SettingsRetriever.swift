//
//  SettingsRetriever.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import Foundation

protocol SettingsRetrieverProtocol {
    func retrieve() -> [String: String]
}

class SettingsRetriever: SettingsRetrieverProtocol {
    private struct Constant {
        static let settingsFileName = "Settings"
    }
    private let plistReader: PlistReaderProtocol
    init(plistReader: PlistReaderProtocol) {
        self.plistReader = plistReader
    }
    
    func retrieve() -> [String: String] {
        guard let plistFile = plistReader.loadPlist(filename: Constant.settingsFileName, bundle: Bundle.main), let result = plistFile as? [String: String] else {
            fatalError("This file MUST exist.")
        }
        return result
    }
}
