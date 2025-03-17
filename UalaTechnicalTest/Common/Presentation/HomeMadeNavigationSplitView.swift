//
//  HomeMadeNavigationSplitView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 16/3/25.
//

import SwiftUI

struct HomeMadeNavigationSplitView<SideBar: View, Detail: View, DefaultDetail: View, DestinationHashKeyType: Hashable>: View {
    
    var loading: Bool
    @Binding var selected: DestinationHashKeyType?
    @ViewBuilder var sidebar: (Bool) -> SideBar
    @ViewBuilder var detail: (DestinationHashKeyType) -> Detail
    @ViewBuilder var defaultDetail: () -> DefaultDetail
    
    var body: some View {
        if loading {
            ProgressView()
        } else {
            GeometryReader { geometry in
                let isPortrait = geometry.size.width < geometry.size.height
                if isPortrait {
                    NavigationStack {
                        sidebar(true)
                            .navigationDestination(for: DestinationHashKeyType.self) { hash in
                                detail(hash)
                                    .onDisappear {
                                        selected = nil
                                    }
                            }
                    }
                } else {
                    let sidebarWidth = geometry.size.width * 0.3
                    let detailWidth = geometry.size.width * 0.7
                    
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
