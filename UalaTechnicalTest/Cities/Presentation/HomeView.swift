//
//  HomeView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 16/3/25.
//

import SwiftUI
import SwiftData

class HomeFactory {
    func create(with context: ModelContext) -> HomeView {
        let listUseCase = ListCitiesUseCaseFactory(context: context).create()
        let markCityAsFavoriteUseCase = MarkCityAsFavoriteUseCaseFactory(context: context).create()
        let unmarkCityAsFavoriteUseCase = UnmarkCityAsFavoriteUseCaseFactory(context: context).create()
        let filterCitiesUseCase = DefaultFilterCitiesUseCase()
        let viewModel = HomeViewModel(listCitiesUseCase: listUseCase, markCityAsFavoriteUseCase: markCityAsFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkCityAsFavoriteUseCase, filterCitiesUseCase: filterCitiesUseCase)
        return .init(viewModel: viewModel)
    }
}

fileprivate enum Constant {
    static let searchEntriesPrompt = "Search entries"
    enum ShowFavoritesButton {
        enum Title {
            static let showingAll = "Show favorites"
            static let showingFavoritesOnly = "Show all"
        }
        enum Icon {
            static let name = "star.fill"
            static let color = Color.yellow
        }
    }
    enum EmptyMap {
        static let title = "Please select one city from the left pane"
    }
}

struct ShowFavoriteButton: View {
    @Binding var favorite: Bool
    var body: some View {
        Button(action: {
            favorite.toggle()
        }) {
            HStack {
                Text(favorite ?
                     Constant.ShowFavoritesButton.Title.showingFavoritesOnly
                     : Constant.ShowFavoritesButton.Title.showingAll)
                if !favorite {
                    Image(systemName: Constant.ShowFavoritesButton.Icon.name)
                        .foregroundColor(Constant.ShowFavoritesButton.Icon.color)
                }
            }
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                HomeMadeNavigationSplitView(selected: $viewModel.selectedCity) { shouldNavigate in
                    CityListFactory()
                        .create(cities: viewModel.filteredCities, selectedCity: $viewModel.selectedCity, shouldNavigate: shouldNavigate, onFavoriteTapped: { city in
                            Task {
                                await viewModel.favoriteTapped(city: city)
                            }
                        })
                        .searchable(text: $viewModel.searchText, prompt: Constant.searchEntriesPrompt)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                ShowFavoriteButton(favorite: $viewModel.showFavoritesOnly)
                            }
                        }
                } detail: { selectedCity in
                    CityMapView(viewModel: viewModel.getSelectedCityMapModel()!)
                } defaultDetail: {
                    Text(Constant.EmptyMap.title)
                }
            }
        }
        .onAppear() {
            viewModel.processOnAppear()
        }
    }
}

#if DEBUG
class FakeListCitiesUseCase: ListCitiesUseCase {
    var result: [City] = []
    func execute() async throws(ListCitiesUseCaseError) {}
    func getResult() throws(ListCitiesUseCaseError) -> Array<City> {
        result
    }
}
class FakeMarkFavoriteUseCase: MarkCityAsFavoriteUseCase {
    func set(newFavorite: City) {}
    func execute() async throws(MarkCityAsFavoriteUseCaseError) {}
}
class FakeUnmarkFavoriteUseCase: UnmarkCityAsFavoriteUseCase {
    func set(favoriteToRemove: City) {}
    func execute() async throws(UnmarkCityAsFavoriteUseCaseError) {}
}
class FakeFilterCitiesUseCase: FilterCitiesUseCase {
    func set(cities: [CityViewModel]) {}
    func set(favoritesOnly: Bool) {}
    func set(searchText: String) {}
    func execute() async throws(FilterCitiesUseCaseError) {}
    func getResult() throws(FilterCitiesUseCaseError) -> Array<CityViewModel> { [] }
}
#endif


#Preview("Portrait", traits: .portrait) {
    @Previewable @State var viewModel: HomeViewModel = {
        let downloadEntriesUseCase = FakeListCitiesUseCase()
        downloadEntriesUseCase.result = [
            City(country: "CO", name: "Medellin", id: 1, favorite: true, coordinates: Coordinate(latitude: 6.25184, longitude: -75.56359)),
            City(country: "AR", name: "Buenos Aires", id: 2, favorite: false, coordinates: Coordinate(latitude: -34.603722, longitude: -58.381592))
        ]
        let markFavoriteUseCase = FakeMarkFavoriteUseCase()
        let unmarkFavoriteUseCase = FakeUnmarkFavoriteUseCase()
        let filterCitiesUseCase = FakeFilterCitiesUseCase()
        
        let result = HomeViewModel(listCitiesUseCase: downloadEntriesUseCase, markCityAsFavoriteUseCase: markFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkFavoriteUseCase, filterCitiesUseCase: filterCitiesUseCase)
        return result
    }()
    HomeView(viewModel: viewModel)
}

#Preview("Landscape right", traits: .landscapeRight) {
    let viewModel: HomeViewModel = {
        let downloadEntriesUseCase = FakeListCitiesUseCase()
        let markFavoriteUseCase = FakeMarkFavoriteUseCase()
        let unmarkFavoriteUseCase = FakeUnmarkFavoriteUseCase()
        let filterCitiesUseCase = FakeFilterCitiesUseCase()
        
        let result = HomeViewModel(listCitiesUseCase: downloadEntriesUseCase, markCityAsFavoriteUseCase: markFavoriteUseCase, unmarkCityAsFavoriteUseCase: unmarkFavoriteUseCase, filterCitiesUseCase: filterCitiesUseCase)
        result.loading = true
        return result
    }()
    HomeView(viewModel: viewModel)
}

