//
//  PayslipSettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/1/23.
//

import SwiftUI

// MARK: - PayslipSettingsView

struct PayslipSettingsView: View {
    @State private var includeStateTaxes = false
    @State private var includeFederalTaxes = false
    @State private var federalRate = ""
    @State private var stateRate = ""

    var body: some View {
        List {
            Section {
                Toggle("Federal", isOn: $includeFederalTaxes)
                if includeFederalTaxes {
                    TextField("Federal tax percentage", text: $federalRate)
                }

                Toggle("State", isOn: $includeStateTaxes)

                if includeStateTaxes {
                    TextField("State tax percentage", text: $stateRate)
                }

            } header: {
                Text("Taxes")
            } footer: {
                Text("Select which taxes to consider when calculating earnings.")
            }

            Section("Deductions") {
            }
        }
        .putInTemplate()
        .toolbarSave {
            
        }
        .navigationTitle("Pay Slip Settings")
        
        
    }
}

// MARK: - PayslipSettingsView_Previews

struct PayslipSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PayslipSettingsView()
            .putInNavView(.inline)
    }
}
