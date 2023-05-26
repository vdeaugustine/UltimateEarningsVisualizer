//
//  PayCycleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - PayCycleView

struct PayCycleView: View {
    @ObservedObject private var user = User.main
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedCycle: PayCycle = .biWeekly
    
    @State private var dayOfWeek: DayOfWeek = .friday
    
    @State private var toastConfig = AlertToast.errorWith(message: "")
    @State private var showToast = false
    
    var body: some View {
        Form {
            Section {
                Picker("Duration", selection: $selectedCycle) {
                    ForEach(PayCycle.allCases) { cycle in
                        Text(cycle.rawValue.capitalized)
                            .tag(cycle)
                    }
                }
            }
            
            Section {
                Picker("Day of Week", selection: $dayOfWeek) {
                    ForEach(DayOfWeek.allCases) { day in
                        Text(day.rawValue.capitalized)
                            .tag(day)
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Pay Cycle")
        .bottomButton(label: "Save") {
            do {
                try PayPeriod(day: dayOfWeek, cycle: selectedCycle, user: user, context: viewContext)
                toastConfig = .successWith(message: "Successfully saved pay cycle")
                showToast.toggle()
            }
            catch {
                toastConfig = .errorWith(message: "Error saving pay cycle")
                showToast.toggle()
            }
            
        }
        .toast(isPresenting: $showToast) {
            toastConfig
        }
    }
}

// MARK: - PayCycleView_Previews

struct PayCycleView_Previews: PreviewProvider {
    static var previews: some View {
        PayCycleView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
