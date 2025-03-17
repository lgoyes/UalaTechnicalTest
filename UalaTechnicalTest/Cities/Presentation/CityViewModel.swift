//
//  CityViewModel.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

struct CityViewModel: Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    var favorite: Bool
}

class CityViewModelFactory {
    func create(city: City) -> CityViewModel {
        let title = "\(city.name), \(city.country)"
        let subtitle = "Lat: \(city.coordinates.latitude), Lon: \(city.coordinates.longitude)"
        return CityViewModel(id: city.id, title: title, subtitle: subtitle, favorite: city.favorite)
    }
}
