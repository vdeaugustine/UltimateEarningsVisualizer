//
//  EnterPaycheckView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/1/23.
//

import SwiftUI

// MARK: - EnterPaycheckView

struct EnterPaycheckView: View {
    @StateObject private var viewModel = EnterPaycheckViewModel()

    var body: some View {
        Form {
            Group {
                Section("Paycheck Gross") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign",
                                                        backgroundColor: viewModel.user.getSettings().themeColor)
                        Text(viewModel.thisCheckGross.money().replacingOccurrences(of: "$", with: ""))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        viewModel.showCheckGrossSheet = true
                    }
                    .sheet(isPresented: $viewModel.showCheckGrossSheet) {
                        EnterMoneyView(dubToEdit: $viewModel.thisCheckGross)
                    }
                }

                Section("Paycheck Taxes") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: viewModel.user.getSettings().themeColor)
                        Text(viewModel.thisCheckTax.money().replacingOccurrences(of: "$", with: ""))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        viewModel.showCheckTaxSheet = true
                    }
                    .sheet(isPresented: $viewModel.showCheckTaxSheet) {
                        EnterMoneyView(dubToEdit: $viewModel.thisCheckTax)
                    }
                }

                Section("YTD Gross") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign",
                                                        backgroundColor: viewModel.user.getSettings().themeColor)
                        Text(viewModel.YTDGross.money().replacingOccurrences(of: "$", with: ""))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        viewModel.showYTDGrossSheet = true
                    }
                    .sheet(isPresented: $viewModel.showYTDGrossSheet) {
                        EnterMoneyView(dubToEdit: $viewModel.YTDGross)
                    }
                }

                Section("YTD Taxes") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign",
                                                        backgroundColor: viewModel.user.getSettings().themeColor)
                        Text(viewModel.YTDTax.money().replacingOccurrences(of: "$", with: ""))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        viewModel.showYTDTaxSheet = true
                    }
                    .sheet(isPresented: $viewModel.showYTDTaxSheet) {
                        EnterMoneyView(dubToEdit: $viewModel.YTDTax)
                    }
                }
            }

            Section("Deductions") {
                Toggle(EnterPaycheckViewModel.Deductions.retirement.rawValue.capitalized,
                       isOn: $viewModel.includeRetirement)
                Toggle(EnterPaycheckViewModel.Deductions.insurance.rawValue.capitalized,
                       isOn: $viewModel.includeInsurance)
                Toggle(EnterPaycheckViewModel.Deductions.stock.rawValue,
                       isOn: $viewModel.includeStocks)
            }

            Section("Rates") {
                Text("YTD Tax")
                    .spacedOut {
                        HStack {
                            Text(viewModel.YTDTaxRate.simpleStr())
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                            SystemImageWithFilledBackground(systemName: "percent", backgroundColor: viewModel.user.getSettings().themeColor)
                        }
                    }

                Text("Paycheck Tax")
                    .spacedOut {
                        HStack {
                            Text(viewModel.paycheckTaxRate.simpleStr())
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                            SystemImageWithFilledBackground(systemName: "percent", backgroundColor: viewModel.user.getSettings().themeColor)
                        }
                    }
            }

            Section("Set Rate") {
                Picker("Rate to Use", selection: $viewModel.typeSelected) {
                    Text(EnterPaycheckViewModel.TypeChoice.YTD.rawValue)
                        .tag(EnterPaycheckViewModel.TypeChoice.YTD)
                    Text(EnterPaycheckViewModel.TypeChoice.paycheck.rawValue)
                        .tag(EnterPaycheckViewModel.TypeChoice.paycheck)
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Enter Paycheck")
        .bottomButton(label: "Save") {
            viewModel.savePaycheck()
        }
    }
}

// MARK: - EnterPaycheckView_Previews

struct EnterPaycheckView_Previews: PreviewProvider {
    static var previews: some View {
        EnterPaycheckView()
            .putInNavView(.inline)
    }
}



