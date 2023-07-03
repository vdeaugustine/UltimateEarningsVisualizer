//
//  CalculateStateTaxView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/2/23.
//

import SwiftUI

// MARK: - CalculateStateTaxView

struct CalculateStateTaxView: View {
    @Binding var stateRate: Double
    @State private var grossEarnings: Double = 0
    @State private var preTaxDeductions: Double = 0
    @State private var stateTaxesPaid: Double = 0
    @State private var showEarningsSheet = false
    @State private var showPreTaxSheet = false
    @State private var showTaxesSheet = false

    var taxRate: Double {
        let taxableIncome = grossEarnings - preTaxDeductions
        if taxableIncome <= 0 {
            return 0
        }
        let taxRate = stateTaxesPaid / taxableIncome
        return taxRate * 100
    }

    var body: some View {
        Form {
            Section("Gross Earnings") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign")
                    Text(grossEarnings.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")).boldNumber()
                    Spacer()
                    Text("Edit")
                }
                .allPartsTappable(alignment: .leading)
                .onTapGesture {
                    showEarningsSheet.toggle()
                }
            }

            Section("Pre Tax Deductions") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign")
                    Text(preTaxDeductions.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")).boldNumber()
                    Spacer()
                    Text("Edit")
                }
                .allPartsTappable(alignment: .leading)
                .onTapGesture {
                    showPreTaxSheet.toggle()
                }
            }

            Section("State Taxes Paid") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign")
                    Text(stateTaxesPaid.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")).boldNumber()
                    Spacer()
                    Text("Edit")
                }
                .allPartsTappable(alignment: .leading)
                .onTapGesture {
                    showTaxesSheet.toggle()
                }
            }

            Section("Tax Rate") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "percent")
                    Text(taxRate.simpleStr(3, false)).boldNumber()
                    Spacer()
                }
            }
            
            Section {
                
            } header: {
                
            } footer: {
                Text("Use any of your recent pay slips to complete this form")
            }
        }
        .sheet(isPresented: $showEarningsSheet, content: {
            EnterDoubleView(dubToEdit: $grossEarnings, format: .dollar)
        })
        .sheet(isPresented: $showPreTaxSheet, content: {
            EnterDoubleView(dubToEdit: $preTaxDeductions, format: .dollar)
        })
        .sheet(isPresented: $showTaxesSheet, content: {
            EnterDoubleView(dubToEdit: $stateTaxesPaid, format: .dollar)
        })
        .bottomButton(label: "Save") {
            stateRate = taxRate
        }
    }
}

// MARK: - CalculateStateTaxView_Previews

struct CalculateStateTaxView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateStateTaxView(stateRate: .constant(10))
    }
}
