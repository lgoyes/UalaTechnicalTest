//
//  ContentView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import SwiftUI

class ContentFactory {
    func create() -> ContentView {
        .init(viewModel: .init())
    }
}

class ContentViewModel: ObservableObject {
    
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentFactory().create()
}
