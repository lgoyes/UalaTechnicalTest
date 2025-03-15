//
//  ModelContextStubFactory.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

import SwiftData
@testable import UalaTechnicalTest

class ModelContextStubFactory {
    func create() -> ModelContext {
        let container = try! ModelContainerFactory().create(storedInMemory: false)
        return ModelContext(container)
    }
}
