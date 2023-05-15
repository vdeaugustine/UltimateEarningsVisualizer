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
        case settings, expenses, home, shifts, today, addShifts, allItems
    }

    @State private var tab: Tabs = .shifts
    @ObservedObject var settings = User.main.getSettings()
   

    var body: some View {
        TabView(selection: $tab) {
            
            RegularScheduleView()
//            HomeView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.home, systemImage: "house")
            
            HomeView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.allItems, systemImage: "dollarsign")
            

            TodayView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.today, systemImage: "bolt.fill")

            SettingsView()
                .putInTemplate()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.settings, systemImage: "gear")
        }
        .tint(settings.themeColor)
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
