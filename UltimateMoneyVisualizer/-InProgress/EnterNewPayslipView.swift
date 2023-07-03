//
//  EnterNewPayslipView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/23/23.
//

import Combine
import SwiftUI

// MARK: - EnterPayslipViewModel

class EnterPayslipViewModel: ObservableObject {
    @Published var grossEarningsString = ""
    @Published var grossEarnings: Double = 0
    @Published var hours: Double = 0
    @Published var deductions: [PayslipItem] = []
    @Published var showSheet = false
    @Published var newItemType: PayslipItem.PayslipItemType = .preTaxDeductions

    var totalDeductionAmount: Double {
        deductions.reduce(Double.zero) { $0 + $1.amount }
    }

    public static var shared = EnterPayslipViewModel()

    func getDeductions(_ type: PayslipItem.PayslipItemType? = nil) -> [PayslipItem] {
        if let type {
            return deductions.filter { $0.type == type }
        }
        return deductions
    }

    func amount(for deductionType: PayslipItem.PayslipItemType) -> Double {
        getDeductions(deductionType)
            .reduce(Double.zero) { $0 + $1.amount }
    }

    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var hoursAsSeconds: Double {
        hours * 60 * 60
    }

    // MARK: - Nested Types

    class PayslipItem: ObservableObject, Identifiable, CustomStringConvertible {
        init(description: String,
             amount: Double,
             YTD: Double? = nil,
             type: EnterPayslipViewModel.PayslipItem.PayslipItemType,
             amountType: EnterPayslipViewModel.PayslipItem.AmountType) {
            self.description = description
            self.amount = amount
            self.YTD = YTD
            self.type = type
            self.amountType = amountType
        }

        let description: String
        let amount: Double
        let YTD: Double?
        let type: PayslipItemType
        let amountType: AmountType

        var id: Self { self }

        enum AmountType: String, CaseIterable, Identifiable, Hashable {
            case percentage = "Percentage"
            case fixedAmount = "Fixed Amount"

            var id: Self { self }
        }

        enum PayslipItemType: String, CaseIterable, Identifiable, Hashable {
            case preTaxDeductions = "Pre Tax Deduction"
            case taxes = "Tax"
            case afterTaxDeductions = "After Tax Deduction"

            var id: Self { self }
        }

        enum TaxesType: String, CaseIterable, Identifiable, Hashable {
            case federalTax = "Federal Tax"
            case socialSecurity = "Social Security"
            case medicare = "Medicare"
            case stateTax = "State Tax"
            case stateDisability = "Disability"
            var id: Self { self }
        }

        enum PreTaxType: String, CaseIterable, Identifiable, Hashable {
            case _401k = "401K"
            case dental = "Dental"
            case vision = "Vision"
            case medical = "Medical"
            var id: Self { self }
        }

        enum AfterTaxType: String, CaseIterable, Identifiable, Hashable {
            case legalPlan = "Legal Plan"
            case ltd = "LTD"
            case criticalIllness = "Critical Illness"
            var id: Self { self }
        }
    }
}

// MARK: - EnterNewPayslipView

struct EnterNewPayslipView: View {
    @StateObject private var viewModel = EnterPayslipViewModel.shared
    @State private var formattedAmount = ""

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencySymbol = ""
        return formatter
    }()

    typealias PayslipType = EnterPayslipViewModel.PayslipItem.PayslipItemType
    typealias AmountType = EnterPayslipViewModel.PayslipItem.AmountType

    var body: some View {
        Form {
            Section("Gross Earnings") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: User.main.getSettings().themeColor)

                    TextField("Gross Earnings", text: $viewModel.grossEarningsString)
                }
            }

            Section("Hours") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "clock", backgroundColor: User.main.getSettings().themeColor)
                    TextField("Hours", value: $viewModel.hours, formatter: NumberFormatter.custom(decimalPlaces: 2))
                        .keyboardType(.decimalPad)

                    Text(viewModel.hoursAsSeconds.formatForTime([.hour, .minute, .second]))
                }
            }

            Section("Total") {
                Text("Net Earnings")
//                    .spacedOut(text: )
                Text("Deductions")
                    .spacedOut(text: viewModel.totalDeductionAmount.formattedForMoney())
                Text("Pre Tax")
                    .spacedOut(text: viewModel.amount(for: .preTaxDeductions).formattedForMoney())
                Text("Tax")
                    .spacedOut(text: viewModel.amount(for: .taxes).formattedForMoney())
                Text("After Tax")
                    .spacedOut(text: viewModel.amount(for: .afterTaxDeductions).formattedForMoney())
            }

            ForEach(viewModel.getDeductions()) { item in
                HStack {
                    Text(item.description)
                    Text(item.type.rawValue)
                        .font(.system(size: 8, weight: .light))
                    Spacer()
                    Text(item.amount.str)
                }
            }

            Button("New") {
//                let newItem = EnterPayslipViewModel.PayslipItem(description: "something",
//                                                                amount: Double.random(in: 100 ... 1000 ),
//                                                                type: .allCases.randomElement()!,
//                                                                amountType: .allCases.randomElement()!)
//                viewModel.deductions.append(newItem)
                viewModel.showSheet.toggle()
            }

            if !viewModel.getDeductions().isEmpty {
                Section("Rates") {
                }
            }
        }

        .sheet(isPresented: $viewModel.showSheet) {
            CreateItemSheet(viewModel: viewModel)
        }
    }

    struct CreateItemSheet: View {
        @ObservedObject var viewModel: EnterPayslipViewModel
        @State private var type: PayslipType = EnterPayslipViewModel.shared.newItemType
        @State private var amountString = ""
        @State private var descriptionString = ""
        @State private var amountType = EnterPayslipViewModel.PayslipItem.AmountType.percentage

        @Environment(\.dismiss) private var dismiss

        var body: some View {
            Form {
                Section("Type") {
                    Picker("Type", selection: $type) {
                        ForEach(PayslipType.allCases) { type in

                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                Section("Amount") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: User.main.getSettings().themeColor)

                        TextField("Amount", text: $amountString)
                            .keyboardType(.decimalPad)
                    }
                }
                Section("Info") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "info.circle")
                        TextField("Description", text: $descriptionString)
                    }
                }

                Section("Amount Type") {
                    Picker("Amount Type", selection: $amountType) {
                        ForEach(AmountType.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                HStack(spacing: 1) {
                    Button {
                        dismiss()
                    } label: {
                        BottomViewButton(label: "Cancel")
                    }

                    Button {
                        guard let double = Double(amountString),
                              !descriptionString.isEmpty
                        else {
                            return
                        }

                        let newItem = EnterPayslipViewModel
                            .PayslipItem(description: descriptionString,
                                         amount: double,
                                         type: type,
                                         amountType: amountType)
                        viewModel.deductions.append(newItem)
                        dismiss()
                    } label: {
                        BottomViewButton(label: "Save")
                    }
                }

            })
//            .toolbarSave {
//                guard let double = Double(amountString),
//                      !descriptionString.isEmpty
//                else {
//                    return
//                }
//
//                let newItem = EnterPayslipViewModel
//                    .PayslipItem(description: descriptionString,
//                                 amount: double,
//                                 type: type,
//                                 amountType: amountType)
//                viewModel.deductions.append(newItem)
//                dismiss()
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Cancel", role: .cancel) { dismiss() }
//                }
//            }
            .putInNavView(.inline)
            .putInTemplate()

            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - EnterNewPayslipView_Previews

struct EnterNewPayslipView_Previews: PreviewProvider {
    static var previews: some View {
        EnterNewPayslipView()
            .putInNavView(.inline)
    }
}
