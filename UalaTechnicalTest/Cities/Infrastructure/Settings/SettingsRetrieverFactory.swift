//
//  SettingsRetrieverFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

class SettingsRetrieverFactory {
    func create() -> SettingsRetrieverProtocol {
        let plistReader = PlistReader()
        let result = SettingsRetriever(plistReader: plistReader)
        return result
    }
}
