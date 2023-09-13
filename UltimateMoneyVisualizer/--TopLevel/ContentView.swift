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

    var body: some View {
        TabView(selection: $navManager.currentTab.onUpdate(ifNoChange: navManager.sameTabTapped)) {
            NavigationStack(path: $navManager.homeNavPath) {
                NewHomeView()
                    .id(navManager.scrollViewID)
            }
            .makeTab(tab: Tabs.newHome, systemImage: "house")

            NavigationStack(path: $navManager.allItemsNavPath) {
                AllItemsView()
            }
            .makeTab(tab: Tabs.allItems, systemImage: "dollarsign")

            NavigationStack(path: $navManager.todayViewNavPath) {
                NewTodayView()
            }
            .makeTab(tab: Tabs.today, systemImage: "bolt.shield")

            NavigationStack(path: $navManager.settingsNavPath) {
                SettingsView()
            }
            .makeTab(tab: Tabs.settings, systemImage: "gear")
            
            
            OnboardingFirstView()
                .makeTab(tab: Tabs.onboarding , systemImage: "play")
            
            
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
    }
}
