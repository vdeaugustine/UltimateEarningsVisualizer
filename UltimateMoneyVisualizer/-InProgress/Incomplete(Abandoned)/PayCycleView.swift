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
    @StateObject private var viewModel: PayCycleViewModel = .init()

    var body: some View {
        Form {
            Section {
                DatePicker("Next pay day",
                           selection: $viewModel.nextPayDay,
                           displayedComponents: .date)
            }

            Section {
                Picker("Pay period length", selection: $viewModel.selectedCycle) {
                    ForEach(PayCycle.allCases) { cycle in
                        Text(cycle.rawValue.capitalized)
                            .tag(cycle)
                    }
                }
            }
            
            Section("Upcoming pay days") {
                ForEach(viewModel.next3PayDays(), id: \.self ) { day in
                    Text(day.getFormattedDate(format: "EEEE M/d/yy"))

                }
            }
        }
        .putInTemplate()
        .navigationTitle("Pay Cycle")
        .bottomButton(label: "Confirm") {
            do {
                try PayPeriod(day: viewModel.dayOfWeek, cycle: viewModel.selectedCycle, user: viewModel.user, context: viewModel.viewContext)
                viewModel.toastConfig = .successWith(message: "Successfully saved pay cycle")
                viewModel.showToast.toggle()
            } catch {
                viewModel.toastConfig = .errorWith(message: "Error saving pay cycle")
                viewModel.showToast.toggle()
            }
        }
        .toast(isPresenting: $viewModel.showToast) {
            viewModel.toastConfig
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
