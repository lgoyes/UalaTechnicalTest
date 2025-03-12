//
//  DBManager.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

protocol DBFacade: DBCityCreatable, DBCityListable, DBCityRemovable {
    
}

class DefaultDBFacade: DBFacade {
    let creatable: DBCityCreatable
    let listable: DBCityListable
    let removable: DBCityRemovable
    init(creatable: DBCityCreatable, listable: DBCityListable, removable: DBCityRemovable) {
        self.creatable = creatable
        self.listable = listable
        self.removable = removable
    }
    
    func create(city: DBCity) {
        creatable.create(city: city)
    }
    
    func remove(city: DBCity) {
        removable.remove(city: city)
    }
    
    func listAllCities() throws(DBCityListableError) -> [DBCity] {
        try listable.listAllCities()
    }
}
