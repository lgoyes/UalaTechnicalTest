//
//  CityList.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityListViewModel {
    let cities: [CityViewModel]
    let shouldNavigate: Bool
    let onFavoriteTapped: ((CityViewModel) -> Void)?
    let onSelected: ((CityViewModel) -> Void)?
    
    func select(city: CityViewModel) {
        onSelected?(city)
    }
    
    func favoriteTapped(for city: CityViewModel) {
        onFavoriteTapped?(city)
    }
}

struct CityListView: View {
    var viewModel: CityListViewModel
    
    private func createCell(with city: CityViewModel) -> CityRowView {
        CityRowView(model: city) {
            viewModel.favoriteTapped(for: city)
        } onSelected: {
            viewModel.select(city: city)
        }
    }
    
    var body: some View {
        // There are so many cities, so I needed an extra optimization fot the list.
        ScrollView {
            LazyVStack {
                ForEach(viewModel.cities, id: \.id) { city in
                    if viewModel.shouldNavigate {
                        NavigationLink(value: city) {
                            createCell(with: city)
                        }
                    } else {
                        createCell(with: city)
                    }
                }
            }
        }
    }
}

class CityListFactory {
    func create(cities: [CityViewModel], shouldNavigate: Bool, onFavoriteTapped: ((CityViewModel) -> Void)? = nil, onSelected: ((CityViewModel) -> Void)? = nil) -> CityListView {
        let viewModel = CityListViewModel(cities: cities, shouldNavigate: shouldNavigate, onFavoriteTapped: onFavoriteTapped, onSelected: onSelected)
        return CityListView(viewModel: viewModel)
    }
}

#Preview {
    @Previewable @State var cities: [CityViewModel] = [
        CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false, selected: false),
        CityViewModel(id: 2, title: "Bogotá, CO", subtitle: "Lat: 2, Lon: 3", favorite: false, selected: false)
    ]
    @Previewable @State var selected: CityViewModel? = nil

    let viewModel = CityListViewModel(cities: cities, shouldNavigate: false) { city in
        if let index = cities.firstIndex(where: { $0.id == city.id } ) {
            cities[index].favorite.toggle()
        }
    } onSelected: { city in
        for i in (0..<cities.count) {
            if cities[i].id != city.id {
                cities[i].selected = false
            } else {
                cities[i].selected = true
                selected = cities[i]
            }
        }
    }

    CityListView(viewModel: viewModel)
}
