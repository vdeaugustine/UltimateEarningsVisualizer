//
//  ContentView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import SwiftUI



// MARK: - ContentView

struct ContentView: View {
    enum Tabs: String, Hashable, CustomStringConvertible {
        var description: String { rawValue.capitalized }
        case settings, expenses, home, shifts
    }

    @State private var tab: Tabs = .shifts

    var body: some View {
        TabView(selection: $tab) {
            ShiftListView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.shifts, systemImage: "calendar")

            SettingsView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.settings, systemImage: "gear")
        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
