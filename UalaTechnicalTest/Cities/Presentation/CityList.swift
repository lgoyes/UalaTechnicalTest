//
//  CityList.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityListViewModel {
    let cities: [CityViewModel]
    @Binding var selectedCity: CityViewModel?
    let shouldNavigate: Bool
    let onFavoriteTapped: ((CityViewModel) -> Void)?
    
    func favoriteTapped(for city: CityViewModel) {
        onFavoriteTapped?(city)
    }
}

struct CityListView: View {
    var viewModel: CityListViewModel
    
    var body: some View {
        // There were so many cities, so I needed an extra optimization fot the list.
        LazyListView(shouldNavigate: viewModel.shouldNavigate, entries: viewModel.cities, selection: viewModel.$selectedCity) { city in
            CityRowView(model: city) {
                viewModel.favoriteTapped(for: city)
            }
        }
    }
}

class CityListFactory {
    func create(cities: [CityViewModel], selectedCity: Binding<CityViewModel?>, shouldNavigate: Bool, onFavoriteTapped: ((CityViewModel) -> Void)? = nil) -> CityListView {
        let viewModel = CityListViewModel(cities: cities, selectedCity: selectedCity, shouldNavigate: shouldNavigate, onFavoriteTapped: onFavoriteTapped)
        return CityListView(viewModel: viewModel)
    }
}

#Preview("List with a selected item") {
    @Previewable @State var cities: [CityViewModel] = [
        CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false),
        CityViewModel(id: 2, title: "Bogotá, CO", subtitle: "Lat: 2, Lon: 3", favorite: true)
    ]
    @Previewable @State var selected: CityViewModel? = CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false)

    let viewModel = CityListViewModel(cities: cities, selectedCity: $selected, shouldNavigate: false) { city in
        if let index = cities.firstIndex(where: { $0.id == city.id } ) {
            cities[index].favorite.toggle()
        }
    }

    CityListView(viewModel: viewModel)
}
