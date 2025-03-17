//
//  HomeMadeNavigationSplitView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 16/3/25.
//

import SwiftUI

fileprivate enum HomeMadeNavigationSplitViewConstant {
    static let sidebarWidthPercentage: Double = 0.3
}

struct HomeMadeNavigationSplitView<SideBar: View, Detail: View, DefaultDetail: View, DestinationHashKeyType: Hashable>: View {

    @Binding var selected: DestinationHashKeyType?
    @ViewBuilder var sidebar: (Bool) -> SideBar
    @ViewBuilder var detail: (DestinationHashKeyType) -> Detail
    @ViewBuilder var defaultDetail: () -> DefaultDetail
    
    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.width < geometry.size.height
            NavigationStack {
                if isPortrait {
                    sidebar(true)
                        .navigationDestination(for: DestinationHashKeyType.self) { hash in
                            detail(hash)
                                .onDisappear {
                                    selected = nil
                                }
                        }
                } else {
                    let sidebarWidth = geometry.size.width * HomeMadeNavigationSplitViewConstant.sidebarWidthPercentage
                    let detailWidth = geometry.size.width * (1 - HomeMadeNavigationSplitViewConstant.sidebarWidthPercentage)
                    
                    HStack {
                        sidebar(false)
                            .frame(width: sidebarWidth)
                        if let selected {
                            detail(selected)
                                .frame(width: detailWidth)
                        } else {
                            defaultDetail()
                                .frame(width: detailWidth)
                        }
                    }
                }
            }
        }
    }
}
