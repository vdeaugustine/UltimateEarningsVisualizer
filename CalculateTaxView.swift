//
//  CalculateStateTaxView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/2/23.
//

import SwiftUI

// MARK: - CalculateStateTaxView

struct CalculateTaxView: View {
    
    enum TaxType: String {
        case state, federal
    }
    @Environment(\.managedObjectContext) private var viewContext
    let taxType: TaxType
    @Binding var bindedRate: Double
    @State private var grossEarnings: Double = User.main.getWage().mostRecentGrossEarningsAmount
    @State private var preTaxDeductions: Double = User.main.getWage().mostRecentPreTaxDeductionsAmount
    @State private var taxesPaid: Double = 0
    @State private var showEarningsSheet = false
    @State private var showPreTaxSheet = false
    @State private var showTaxesSheet = false
    @ObservedObject private var wage = User.main.getWage()
    @Environment (\.dismiss) private var dismiss

    var taxRate: Double {
        let taxableIncome = grossEarnings - preTaxDeductions
        if taxableIncome <= 0 {
            return 0
        }
        let taxRate = taxesPaid / taxableIncome
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

            Section("\(taxType.rawValue.capitalized) Taxes Paid") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign")
                    Text(taxesPaid.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")).boldNumber()
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
            EnterDoubleView(dubToEdit: $taxesPaid, format: .dollar)
        })
        .bottomButton(label: "Save") {
            bindedRate = taxRate
            wage.mostRecentGrossEarningsAmount = grossEarnings
            wage.mostRecentPreTaxDeductionsAmount = preTaxDeductions
            switch taxType {
            case .state:
                wage.mostRecentStateTaxesPaid = taxesPaid
            case .federal:
                wage.mostRecentFederalTaxesPaid = taxesPaid
            }
            
            try? viewContext.save()
            dismiss()
        }
        .navigationTitle("Calculate \(taxType.rawValue.capitalized) Tax")
        .putInTemplate()
    }
}

// MARK: - CalculateStateTaxView_Previews

struct CalculateTaxView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateTaxView(taxType: .federal, bindedRate: .constant(10))
            .putInNavView(.inline)
    }
}
