//
//  ContentView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import SwiftUI
import Vin
//extension Binding {
//    func onUpdate(ifNoChange closureForNoChange: @escaping (Value) -> Void,
//                  completion: ((Value) -> Void)? = nil) -> Binding<Value> where Value: Equatable {
//        Binding(get: { wrappedValue },
//                set: {
//                    if $0 == wrappedValue {
//                        closureForNoChange($0)
//                    }
//                    wrappedValue = $0
//                    completion?(wrappedValue)
//                })
//    }
//}

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
        TabView(selection: $navManager.currentTab.onUpdate(ifNoChange: navManager.sameTabTapped)) {
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

            NavigationStack(path: $navManager.allItemsNavPath){
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
