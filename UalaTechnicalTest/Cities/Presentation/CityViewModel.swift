//
//  CityViewModel.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

struct CityViewModel {
    let id: Int
    let title: String
    let subtitle: String
    var favorite: Bool
    var selected: Bool
}

class CityViewModelFactory {
    func create(city: City, selectedCityId: Int?) -> CityViewModel {
        let title = "\(city.name), \(city.country)"
        let subtitle = "Lat: \(city.coordinates.latitude), Lon: \(city.coordinates.longitude)"
        return CityViewModel(id: city.id, title: title, subtitle: subtitle, favorite: city.favorite, selected: city.id == selectedCityId ?? -1)
    }
}
