//
//  EnterPaycheckView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/1/23.
//

import SwiftUI

// MARK: - EnterPaycheckView

struct EnterPaycheckView: View {
    @State private var thisCheckGross: Double = 0
    @State private var thisCheckTax: Double = 0
    @State private var YTDGross: Double = 0
    @State private var YTDTax: Double = 0

    @State private var showCheckGrossSheet = false
    @State private var showCheckTaxSheet = false
    @State private var showYTDGrossSheet = false
    @State private var showYTDTaxSheet = false
    
    @State private var typeSelected = TypeChoice.YTD
    

    @ObservedObject private var user = User.main
    
    enum TypeChoice: String {
        case YTD, paycheck = "Paycheck"
    }

    private var YTDTaxRate: Double {
        guard YTDGross > 0 else { return 0 }
        return YTDTax / YTDGross * 100
    }
    
    private var paycheckTaxRate: Double {
        guard thisCheckGross > 0 else { return 0 }
        return thisCheckTax / thisCheckGross * 100
    }

    var body: some View {
        Form {
            Section("Paycheck Gross") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(thisCheckGross.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(user.getSettings().getDefaultGradient())
                    Spacer()
                }
                .allPartsTappable()
                .onTapGesture {
                    showCheckGrossSheet = true
                }
            }

            Section("Paycheck Taxes") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(thisCheckTax.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(user.getSettings().getDefaultGradient())
                    Spacer()
                }
                .allPartsTappable()
                .onTapGesture {
                    showCheckTaxSheet = true
                }
            }

            Section("YTD Gross") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(YTDGross.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(user.getSettings().getDefaultGradient())
                    Spacer()
                }
                .allPartsTappable()
                .onTapGesture {
                    showYTDGrossSheet = true
                }
            }

            Section("YTD Taxes") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(YTDTax.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(user.getSettings().getDefaultGradient())
                    Spacer()
                }
                .allPartsTappable()
                .onTapGesture {
                    showYTDTaxSheet = true
                }
            }

            Section("Rates") {
                Text("YTD Tax")
                    .spacedOut {
                        HStack {
                            Text(YTDTaxRate.simpleStr())
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                            SystemImageWithFilledBackground(systemName: "percent", backgroundColor: user.getSettings().themeColor)
                        }
                    }
                
                Text("Paycheck Tax")
                    .spacedOut {
                        HStack {
                            Text(paycheckTaxRate.simpleStr())
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                            SystemImageWithFilledBackground(systemName: "percent", backgroundColor: user.getSettings().themeColor)
                        }
                    }
            }
            
            Section ("Set Rate") {
                Picker("Rate to Use", selection: $typeSelected) {
                    Text(TypeChoice.YTD.rawValue)
                        .tag(TypeChoice.YTD)
                    Text(TypeChoice.paycheck.rawValue)
                        .tag(TypeChoice.paycheck)
                }
            }
            
            
        }
        .putInTemplate()
        .navigationTitle("Enter Paycheck")
        .sheet(isPresented: $showCheckGrossSheet) {
            EnterMoneyView(dubToEdit: $thisCheckGross)
        }
        .sheet(isPresented: $showCheckTaxSheet) {
            EnterMoneyView(dubToEdit: $thisCheckTax)
        }
        .sheet(isPresented: $showYTDGrossSheet) {
            EnterMoneyView(dubToEdit: $YTDGross)
        }
        .sheet(isPresented: $showYTDTaxSheet) {
            EnterMoneyView(dubToEdit: $YTDTax)
        }
        .bottomButton(label: "Save") {
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
