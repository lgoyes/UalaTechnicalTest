//
//  DBCityRemover.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//
import SwiftData

protocol DBCityRemovable {
    func remove(city: DBCity)
}

class DefaultDBCityRemover: DBCityRemovable {
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    func remove(city: DBCity) {
        context.delete(city)
    }
}
