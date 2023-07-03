//
//  CalculateTaxesView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/28/23.
//

import PDFKit
import SwiftUI
import Vin

// MARK: - PayslipItem2

class PayslipItem2: Hashable {
    let title: String
    let amount: Double

    let rateType: ItemType

    static func == (lhs: PayslipItem2, rhs: PayslipItem2) -> Bool {
        return lhs.title == rhs.title && lhs.amount == rhs.amount && lhs.rateType == rhs.rateType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(amount)
        hasher.combine(rateType)
    }

    init(title: String, amount: Double, rateType: ItemType) {
        self.title = title
        self.amount = amount
        self.rateType = rateType
    }

    enum ItemType: String, CaseIterable {
        case fixedAmount = "Fixed Amount"
        case percentage = "Percentage"
    }
}

// MARK: - PostTaxDeduction

class PostTaxDeduction: PayslipItem2 {
}

// MARK: - PreTaxDeduction

class PreTaxDeduction: PayslipItem2 {
}

// MARK: - Tax

class Tax: PayslipItem2 {
}

// MARK: - TaxCalculatorView

struct TaxCalculatorView: View {
    @State private var grossEarningsStr = ""
    @State private var preTaxDeductions = ""
    @State private var federalTax = ""
    @State private var stateTax = ""
    @State private var medicare = ""
    @State private var disability = ""
    @State private var deductions: [PayslipItem2] = []

    @State private var showNewItem = false

    private var preTaxAmount: Double {
        deductions
            .compactMap { $0 as? PreTaxDeduction }
            .reduce(Double.zero) { $0 + $1.amount }
    }

    private var postTaxAmount: Double {
        deductions
            .compactMap { $0 as? PostTaxDeduction }
            .reduce(Double.zero) { $0 + $1.amount }
    }

    var body: some View {
        List {
            Section("Gross Earnings") {
                TextField("Total Earned", text: $grossEarningsStr)
                
                    Text("Something")
                    .padding(.leading)
                    .padding(.leading)
                
            }

            Section("Deductions and Taxes") {
                ForEach(deductions, id: \.title) { deduction in
                    Text(deduction.title)
                }

                Button("New") {
                }
            }
            
           
        }
        .sheet(isPresented: $showNewItem, content: {
            Form {
                
            }
        })
    }
}

// MARK: - TaxCalculatorView_Previews

struct TaxCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        TaxCalculatorView()
    }
}
