//
//  CityList.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityListViewModel: Observable {
    @Binding var cities: [City]
    @Binding var selectedCity: City?
    
    func select(city: City) {
        selectedCity = city
    }
}

struct CityListView: View {

    @State var viewModel: CityListViewModel
    
    var body: some View {
        List(viewModel.cities, id: \.id) { city in
            CityRowFactory().create(with: city, selectedCity: viewModel.selectedCity)
                .onTapGesture {
                    viewModel.select(city: city)
                }
        }
    }
}

class CityListFactory {
    func create(cities: Binding<[City]>, selectedCity: Binding<City?>) -> CityListView {
        let viewModel = CityListViewModel(cities: cities, selectedCity: selectedCity)
        let result = CityListView(viewModel: viewModel)
        return result
    }
}

#Preview {
    let city = City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359))
    let viewModel = CityListViewModel(cities: .constant([city]), selectedCity: .constant(nil))
    CityListView(viewModel: viewModel)
}
