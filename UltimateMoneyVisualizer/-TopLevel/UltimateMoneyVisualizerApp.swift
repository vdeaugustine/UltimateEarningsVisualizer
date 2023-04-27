//
//  UltimateMoneyVisualizerApp.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import SwiftUI

@main
struct UltimateMoneyVisualizerApp: App {
    #if DEBUG
    let persistenceController = PersistenceController.preview
    #else
    let persistenceController = PersistenceController.shared
    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
