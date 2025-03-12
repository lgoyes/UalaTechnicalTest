//
//  DBFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftData

class ModelContainerFactory {
    enum Error: Swift.Error {
        case unableToCreateDB
    }
    
    func create(storedInMemory: Bool) throws(ModelContainerFactory.Error) -> ModelContainer {
        let schema = Schema([
            DBCity.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: storedInMemory
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            throw .unableToCreateDB
        }
    }
}
