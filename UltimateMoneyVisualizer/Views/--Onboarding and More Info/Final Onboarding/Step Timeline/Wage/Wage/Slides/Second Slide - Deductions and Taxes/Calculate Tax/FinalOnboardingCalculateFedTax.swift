//
//  FinalOnboardingCalculateFedTax.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingCalculateFedTax: View {
    @EnvironmentObject private var viewModel: FinalWageViewModel

    @State private var grossEarnings: Double = 12343
    @State private var preTaxDeductions: Double = 321
    @State private var federalTaxesPaid: Double = 271
    @State private var showAmountSheet = false

    @State private var grossTapped = false
    @State private var preTaxTapped = false
    @State private var taxesPaidTapped = false

    @State private var moreInfoTapped = false

    var calculatedPercentage: Double {
        taxRate
    }

    var percentageString: String {
        let multiplied = calculatedPercentage
        return "\(multiplied.simpleStr())%"
    }

    
    var taxRate: Double {
        let taxableIncome = grossEarnings - preTaxDeductions
        if taxableIncome <= 0 {
            return 0
        }
        let taxRate = federalTaxesPaid / taxableIncome
        return taxRate * 100
    }


    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                FinalOnboardingTitleAndSubtitle(title: "Calculate Federal Tax", subtitle: "", geo: geo)

                VStack {
                    Row(label: "Gross Earnings", value: grossEarnings.money()) {
                        grossTapped = true
                    }

                    Row(label: "Pre Tax Deductions", value: preTaxDeductions.money()) {
                        preTaxTapped = true
                    }
                    Row(label: "Federal Taxes Paid", value: federalTaxesPaid.money()) {
                        taxesPaidTapped = true
                    }
                }

                Row(label: "Calculated Tax Percentage", value: percentageString, chevron: false)

                Spacer()

                VStack(spacing: 10) {
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle")
                        Text("More Info")
                    }
                    
                    OnboardingButton(title: "Continue") {
                        
                    }.padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, widthScaler(24, geo: geo))

            .sheet(isPresented: $grossTapped, content: {
                FinalOnboardingEnterAmount(amount: $grossEarnings, format: .money) {
                    enterButton
                }
            })
            .sheet(isPresented: $preTaxTapped, content: {
                FinalOnboardingEnterAmount(amount: $preTaxDeductions, format: .money) {
                    enterButton
                }
            })
            .sheet(isPresented: $taxesPaidTapped, content: {
                FinalOnboardingEnterAmount(amount: $federalTaxesPaid, format: .money) {
                    enterButton
                }
            })
        }
        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
        .fontDesign(.rounded)
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: viewModel.stepPercentage,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP \(Int(viewModel.stepNumber)) OF \(viewModel.totalStepCount)")
                .font(.system(.title3, design: .rounded))
        }
    }

    func Row(label: String, value: String, chevron: Bool = true, _ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(label)
                        .font(.system(size: 24, weight: .medium, design: .rounded))

                    Text(value)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .pushLeft()
                }

                if chevron {
                    Spacer()

                    Components.nextPageChevron
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                UIColor.systemBackground.color
                    .opacity(0.35)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .buttonStyle(.plain)
    }

    func Row(label: String, value: String, chevron: Bool = true) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.system(size: 24, weight: .medium, design: .rounded))

                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .pushLeft()
            }

            if chevron {
                Spacer()

                Components.nextPageChevron
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            UIColor.systemBackground.color
                .opacity(0.35)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var enterButton: some View {
        Text("Enter")
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                Color.accentColor
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            .padding(.horizontal, 50)
    }
}

extension FinalOnboardingCalculateFedTax {
    func widthScaler(_ width: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameWidth = geo.size.width
        let coefficient = frameWidth / 393
        return coefficient * width
    }

    func heightScaler(_ height: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameHeight = geo.size.height
        let coefficient = frameHeight / 852
        return coefficient * height
    }
    
}

#Preview {
    FinalOnboardingCalculateFedTax()
        .environmentObject(FinalWageViewModel())
}
