//
//  CityList.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityListViewModel {
    @Binding var cities: [CityViewModel]
    @Binding var selectedCity: CityViewModel?
    
    func select(city: CityViewModel) {
        turnOldSelectedOff()
        turnNewSelectedOn(city)
    }
    
    private func turnOldSelectedOff() {
        selectedCity?.selected = false
    }
    
    private func turnNewSelectedOn(_ city: CityViewModel) {
        selectedCity = city
        selectedCity?.selected.toggle()
    }
    
    func favoriteTapped(for city: CityViewModel) {
        guard let favoriteTappedCityIndex = cities.firstIndex(where: { $0.id == city.id }) else {
            return
        }
        cities[favoriteTappedCityIndex].favorite.toggle()
    }
}

struct CityListView: View {

    var viewModel: CityListViewModel
    
    var body: some View {
        List(viewModel.cities, id: \.id) { city in
            CityRowView(model: city) {
                viewModel.favoriteTapped(for: city)
            } onSelected: {
                viewModel.select(city: city)
            }
        }
    }
}

class CityListFactory {
    func create(cities: Binding<[CityViewModel]>, selectedCity: Binding<CityViewModel?>) -> CityListView {
        let viewModel = CityListViewModel(cities: cities, selectedCity: selectedCity)
        let result = CityListView(viewModel: viewModel)
        return result
    }
}

#Preview {
    @Previewable @State var cities: [CityViewModel] = [
        CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false, selected: false),
        CityViewModel(id: 2, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false, selected: false)
    ]
    @Previewable @State var selected: CityViewModel? = nil

    let viewModel = CityListViewModel(cities: $cities, selectedCity: $selected)
    CityListView(viewModel: viewModel)
}
