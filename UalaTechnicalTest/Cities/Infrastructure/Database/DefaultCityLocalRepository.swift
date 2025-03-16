//
//  DefaultCityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

typealias CityLocalRepository = CityCreateLocalRepository & CityListLocalRepository & CityUpdateLocalRepository & CityRemoveLocalRepository

class DefaultCityLocalRepository {
    private enum Error: Swift.Error {
        case cityNotFoundInDB, couldNotListEntries
    }
    private let db: DBFacade
    private let mapper: DBCityMapper
    init(db: DBFacade, mapper: DBCityMapper) {
        self.db = db
        self.mapper = mapper
    }
    
    private func getCity(by id: Int) throws(DefaultCityLocalRepository.Error) -> DBCity {
        let dbResult: [DBCity]
        do {
            dbResult = try db.listAllCities()
        } catch {
            throw .couldNotListEntries
        }
        
        guard let dbCity = dbResult.first(where: { $0.id == id }) else {
            throw .cityNotFoundInDB
        }
        
        return dbCity
    }
}

extension DefaultCityLocalRepository: CityCreateLocalRepository {
    func create(city: City) {
        let dbCity = mapper.invert(city)
        db.create(city: dbCity)
    }
}
//3119841
extension DefaultCityLocalRepository: CityListLocalRepository {
    func listAllCities() throws(CityListLocalRepositoryError) -> [City] {
        do {
            let dbResult = try db.listAllCities()
            return dbResult.map { [unowned self] in mapper.map($0) }
        } catch {
            throw .couldNotListEntries
        }
    }
}

extension DefaultCityLocalRepository: CityRemoveLocalRepository {
    func remove(city: City) throws(CityRemoveLocalRepositoryError){
        do {
            let dbCityToRemove = try getCity(by: city.id)
            db.remove(city: dbCityToRemove)
        } catch {
            throw .cityNotFoundInDB
        }
    }
}

extension DefaultCityLocalRepository: CityUpdateLocalRepository {
    func update(city: City) throws(CityUpdateLocalRepositoryError) {
        let dbCityToUpdate: DBCity
        do {
            dbCityToUpdate = try getCity(by: city.id)
        } catch {
            throw .cityNotFoundInDB
        }
        dbCityToUpdate.name = city.name
        dbCityToUpdate.country = city.country
        dbCityToUpdate.favorite = city.favorite
        dbCityToUpdate.latitude = city.coordinates.latitude
        dbCityToUpdate.longitude = city.coordinates.longitude
    }
}

/// TODO:
/// 1. Remove update
/// 2. Change create to check first that no other entry exists with the same id

