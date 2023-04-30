//
//  UltimateMoneyVisualizerApp.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import SwiftUI

@main
struct UltimateMoneyVisualizerApp: App {
    
    let persistenceController = PersistenceController.shared
    let context = PersistenceController.context

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
        }
    }
}
