//
//  DBCityCreator.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftData

protocol DBCityCreatable {
    func create(city: DBCity)
}

class DefaultDBCityCreator: DBCityCreatable {
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    func create(city: DBCity) {
        context.insert(city)
        try! context.save()
    }
}
