//
//  CityViewModel.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 15/3/25.
//

struct CityViewModel {
    var id: Int { city.id }
    var title: String { "\(city.name), \(city.country)" }
    var subtitle: String { "Lat: \(city.coordinates.latitude), Lon: \(city.coordinates.longitude)" }
    var favorite: Bool {
        get {
            city.favorite
        }
        set {
            city.favorite = newValue
        }
    }
    var selected: Bool
    private var city: City
    init(associatedCity: City, selected: Bool) {
        self.selected = selected
        self.city = associatedCity
    }
}

class CityViewModelFactory {
    func create(city: City) -> CityViewModel {
        return CityViewModel(
            associatedCity: city,
            selected: false
        )
    }
}
