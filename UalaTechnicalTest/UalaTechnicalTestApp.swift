//
//  UalaTechnicalTestApp.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 11/3/25.
//

import SwiftUI
import SwiftData

@main
struct UalaTechnicalTestApp: App {
    let modelContainer: ModelContainer = try! ModelContainerFactory().create(storedInMemory: false)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
