//
//  DefaultCityLocalRepository.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 14/3/25.
//

typealias CityLocalRepository = CityCreateLocalRepository & CityListLocalRepository & CityRemoveLocalRepository

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
    func create(city: City) throws(CityCreateLocalRepositoryError){
        let existingCity: DBCity?
        do {
            existingCity = try getCity(by: city.id)
        } catch .couldNotListEntries {
            throw .unexpectedError
        } catch {
            existingCity = nil
        }
        
        guard existingCity == nil else {
            throw .cityAlreadyExists
        }
        
        let dbCity = mapper.invert(city)
        db.create(city: dbCity)
    }
}

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
        let existingCity: DBCity
        do {
            existingCity = try getCity(by: city.id)
        } catch .couldNotListEntries {
            throw .unexpectedError
        } catch {
            throw .cityNotFoundInDB
        }
        
        db.remove(city: existingCity)
    }
}

