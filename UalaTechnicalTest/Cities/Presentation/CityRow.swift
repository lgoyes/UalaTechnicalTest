//
//  CityRow.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 12/3/25.
//

import SwiftUI

struct CityRowView: View {
    private enum Constant {
        enum FavoriteIconName {
            static let favorite = "star.fill"
            static let notFavorite = "star"
        }
        enum SelectedCell {
            static let color = Color.blue.opacity(0.5)
        }
    }
    let model: CityViewModel
    var onFavoriteTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                info()
            }
            Spacer()
            favoriteIcon()
                .onTapGesture {
                    onFavoriteTapped?()
                }
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

#Preview("Some cell, no favorite", traits: .sizeThatFitsLayout) {
    @Previewable @State var viewModel = CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: false)
    CityRowView(model: viewModel, onFavoriteTapped: {
        viewModel.favorite.toggle()
    })
}

#Preview("Some cell, favorite", traits: .sizeThatFitsLayout) {
    @Previewable @State var viewModel = CityViewModel(id: 1, title: "Medellín, CO", subtitle: "Lat: 1, Lon: 2", favorite: true)
    CityRowView(model: viewModel, onFavoriteTapped: {
        viewModel.favorite.toggle()
    })
}
