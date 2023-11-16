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
    @Environment(\.sizeCategory) var sizeCategory
    @State private var lastTab: Tabs = .testingCalendar
    @ObservedObject private var user: User = .main
    
    @State private var showOnboarding: Bool = !User.main.getStatusTracker().hasSeenOnboardingFlow
    @State private var status: StatusTracker = User.main.statusTracker!
    
    
    var body: some View {
        Group {
            if showOnboarding {
                FinalOnboarding(user: user, showOnboarding: $showOnboarding)
            } else {
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

                    //            TestingEventKit()
                    //                .putInNavView(.large)
                    //                .makeTab(tab: Tabs.testingCalendar, systemImage: "calendar")

                    NavigationStack(path: $navManager.settingsNavPath) {
                        SettingsView()
                    }
                    .makeTab(tab: Tabs.settings, systemImage: "gear")

                    //            #if DEBUG

                   

                    //            #endif
                    //
                }
                .tint(Color.accentColor)
            }
        }
//        .onAppear {
//            print("show onboarding is right now", showOnboarding)
//            let status = user.getStatusTracker()
//            showOnboarding = status.hasSeenOnboardingFlow
//            print("NOw it is \(showOnboarding)")
//        }
//        .onChangeProper(of: user.statusTracker?.hasSeenOnboardingFlow) {
//            print("NEW SHOW ONBOARDING", showOnboarding)
//        }
        
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .environmentObject(NavManager())
            .environmentObject(User.main)
    }
}
