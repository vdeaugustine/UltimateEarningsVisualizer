//
//  PayCycleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - PayPeriodSettingsView

struct PayPeriodSettingsView: View {
    @StateObject private var viewModel: PayPeriodSettingsViewModel = .init()

    var body: some View {
        Form {
            Section {
                Picker("Pay period length", selection: $viewModel.selectedCycle) {
                    ForEach(PayCycle.allCases) { cycle in
                        Text(cycle.rawValue.capitalized)
                            .tag(cycle)
                    }
                }
            }

            Section {
                Toggle("Auto generate next period", isOn: $viewModel.automaticallyGeneratePayPeriods)
            } footer: {
                Text(viewModel.autoGenerateFooterString)
            }

            if viewModel.automaticallyGeneratePayPeriods {
                Section("Next Pay Period") {
                    DatePicker("First Day",
                               selection: $viewModel.firstDay,
                               displayedComponents: .date)

                    DatePicker("Pay Day",
                               selection: $viewModel.nextPayDay,
                               displayedComponents: .date)
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Pay Period Settings")
        .bottomButton(label: "Next") { viewModel.confirmAction() }
        .toast(isPresenting: $viewModel.showToast) {
            viewModel.toastConfig
        }
        .alert(viewModel.createPreviousText, isPresented: $viewModel.showAlertToCreatePreviousPeriods) {
            Button("Create", action: viewModel.confirmedCreateOnAlert)
            
            Button("No", role: .cancel) {}
        }
    }
}

// MARK: - PayPeriodSettingsView_Previews

struct PayPeriodSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PayPeriodSettingsView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
