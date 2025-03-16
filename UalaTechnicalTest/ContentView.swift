//
//  ContentView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HomeFactory().create(with: modelContext)
    }
}



#Preview() {
    ContentView()
}
