//
//  DBCityLister.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftData
import Foundation

enum DBCityListableError: Swift.Error {
    case listingFailed
}
protocol DBCityListable {
    func listAllCities() throws(DBCityListableError) -> [DBCity]
}

class DefaultDBCityLister: DBCityListable {
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    func listAllCities() throws(DBCityListableError) -> [DBCity] {
        do {
            return try context.fetch(FetchDescriptor<DBCity>(sortBy: [SortDescriptor<DBCity>(\DBCity.name, order: .forward)]))
        } catch {
            throw .listingFailed
        }
    }
}
