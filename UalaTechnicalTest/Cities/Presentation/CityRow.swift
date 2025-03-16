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
    var onSelected: (() -> Void)?

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
        .contentShape(Rectangle())
        .onTapGesture {
            onSelected?()
        }
        .background(model.selected ? Constant.SelectedCell.color : .clear)
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
    @Previewable @State var viewModel = CityViewModel(associatedCity: City(country: "CO", name: "Medellín", id: 1, favorite: false, coordinates: Coordinate(latitude: 1, longitude: 2)), selected: false)
    CityRowView(model: viewModel, onFavoriteTapped: {
        viewModel.favorite.toggle()
    }, onSelected:  {
        viewModel.selected.toggle()
    })
}
