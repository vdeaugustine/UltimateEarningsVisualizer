//
//  ContentView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var navManager: NavManager
    typealias Tabs = NavManager.Tabs
    @State private var tab: Tabs = .home
    @ObservedObject var settings = User.main.getSettings()
    @Environment(\.sizeCategory) var sizeCategory
    @State private var lastTab: Tabs = .home
    
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        TabView(selection: $tab.onUpdate(ifNoChange: navManager.sameTabTapped)) {
//            NavigationStack(path: $navManager.homeNavPath) {
//                HomeView()
//                    .id(navManager.scrollViewID)
//            }
//            .makeTab(tab: Tabs.home, systemImage: "house")
            
            NavigationStack(path: $navManager.homeNavPath) {
                NewHomeView()
                    .id(navManager.scrollViewID)
            }
            .makeTab(tab: Tabs.newHome, systemImage: "house")

            AllItemsView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.allItems, systemImage: "dollarsign")
//
            NavigationStack(path: $navManager.todayViewNavPath) {
                NewTodayView()
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .makeTab(tab: Tabs.today, systemImage: "bolt.shield")

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
