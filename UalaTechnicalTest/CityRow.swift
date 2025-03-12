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

#Preview(traits: .sizeThatFitsLayout) {
    let favoriteModel = CityRowViewModel(title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: true)
    CityRowView(model: favoriteModel)
    
    let notFavoriteModel = CityRowViewModel(title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false)
    CityRowView(model: notFavoriteModel)
}
