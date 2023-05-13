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
    
    let savedAlloc: Allocation = {
        let context = PersistenceController.context
        do {
            let saved = try Saved(amount: 123, title: "Laptop", date: .now.addDays(-2), user: User.main, context: User.main.getContext())
            let expense = Expense(title: "Car payment", info: "Monthly", amount: 800, dueDate: .now.addDays(20), user: User.main)
            
            let alloc = try Allocation(amount: 100, expense: expense, goal: nil, shift: nil, saved: saved, date: .now, context: context)
            return alloc
        } catch {
            print("Error", error)
            fatalError(String(describing: error))
        }
        
        
        
    }()


    var body: some View {
        TabView(selection: $tab) {
            
            AllocationDetailView(allocation: savedAlloc)
            
            AllItemsView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.allItems, systemImage: "dollarsign")
            
            HomeView()
                .putInNavView(.inline)
                .makeTab(tab: Tabs.home, systemImage: "house")

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
