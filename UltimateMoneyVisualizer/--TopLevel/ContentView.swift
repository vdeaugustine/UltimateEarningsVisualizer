//
//  ContentView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import SwiftUI

// MARK: - NavManager

class NavManager: ObservableObject {
    static var shared: NavManager = NavManager()

    @Published var homeNavPath: NavigationPath = .init()
    @Published var settingsNavPath: NavigationPath = .init()
    @Published var lastPath: PossiblePaths = .none

    func clearAllPaths() {
        homeNavPath = .init()
        settingsNavPath = .init()
    }

    enum PossiblePaths: Hashable {
        case home
        case settings
        case today
        case none
    }
}

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var navManager: NavManager

    enum Tabs: String, Hashable, CustomStringConvertible {
        var description: String { rawValue.capitalized }
        case settings, expenses, home, shifts, today, addShifts, allItems
    }

    @State private var tab: Tabs = .shifts
    @ObservedObject var settings = User.main.getSettings()
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        TabView(selection: $tab) {
            
            EnterNewPayslipView()
            
            
            NavigationStack(path: $navManager.homeNavPath) {
                HomeView()
            }
            .makeTab(tab: Tabs.home, systemImage: "house")

            AllItemsView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.allItems, systemImage: "dollarsign")

            TodayView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.today, systemImage: "bolt.fill")

            SettingsView()
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
            .environmentObject(NavManager())
//            .environment(\.sizeCategory, .large) // Set a fixed size category for the entire app
    }
}
