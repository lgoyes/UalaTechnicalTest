//
//  CityRow.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityRowViewModel {
    let title: String
    let subtitle: String
    let favorite: Bool
    let selected: Bool
}

struct CityRowView: View {
    private enum Constant {
        enum FavoriteIconName {
            static let favorite = "star.fill"
            static let notFavorite = "star"
        }
    }
    let model: CityRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                info()
            }
            Spacer()
            favoriteIcon()
        }
        .background(model.selected ? .blue.opacity(0.5) : .clear)
    }
    
    // Just for showing-off
    @ViewBuilder
    private func info() -> some View {
        Text(model.title)
            .font(.headline)
        Text(model.subtitle)
            .font(.subheadline)
    }
    
    private func favoriteIcon() -> some View {
        Image(systemName: model.favorite ? Constant.FavoriteIconName.favorite : Constant.FavoriteIconName.notFavorite)
            .foregroundStyle(model.favorite ? .yellow : .gray)
    }
}

class CityRowFactory {
    func create(with city: City, selectedCity: City?) -> CityRowView {
        let title = "\(city.name), \(city.country)"
        let subtitle = "Lat: \(city.coordinates.latitude), Lon: \(city.coordinates.longitude)"
        let viewModel = CityRowViewModel(title: title, subtitle: subtitle, favorite: city.favorite, selected: city.id == selectedCity?.id ?? -1)
        return CityRowView(model: viewModel)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let favoriteModel = CityRowViewModel(title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: true, selected: true)
    CityRowView(model: favoriteModel)
    
    let notFavoriteModel = CityRowViewModel(title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false, selected: false)
    CityRowView(model: notFavoriteModel)
}
