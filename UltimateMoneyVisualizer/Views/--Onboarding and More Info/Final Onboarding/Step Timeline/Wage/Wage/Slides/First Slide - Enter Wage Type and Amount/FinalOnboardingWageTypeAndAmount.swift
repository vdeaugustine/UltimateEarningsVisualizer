//
//  FinalOnboardingWageEnterWalkthrough.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/28/23.
//

import SwiftUI

struct FinalOnboardingWageTypeAndAmount: View {
    @EnvironmentObject private var viewModel: FinalWageViewModel

    

    var bottomButtonLabel: String {
        if viewModel.wageAmount == nil {
            return "Enter Amount"
        }
        return "Continue"
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                

                TitleAndContent(geo: geo)

                if let amount = viewModel.wageAmount {
                    VStack(spacing: 10) {
                        Text("Amount")
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .pushLeft()
                        Text(amount.money())
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .pushLeft()
                    }
                    .padding()
                    .background {
                        UIColor.systemBackground.color
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .opacity(0.35)
                    }
                }

                Spacer()

                if viewModel.wageType != nil {
                    ContinueButton
                }
            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }


        .sheet(isPresented: $viewModel.showWageAmountSheet) {
            FinalOnboardingEnterWageAmountSheet()
        }
    }

    @ViewBuilder func optionRow(type: WageType) -> some View {
        Text(type.rawValue.capitalized)
            .font(.system(.headline, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                UIColor.systemBackground.color
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(0.35)
                    .conditionalModifier(viewModel.wageType == type) { thisView in
                        thisView
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            }
                    }
            }
            .onTapGesture {
                withAnimation {
                    viewModel.wageType = type
                }
            }
    }

    

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("Do you have an hourly wage or are you salaried?")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            VStack(alignment: .leading) {
                ForEach(WageType.allCases) { type in
                    optionRow(type: type)
                }
            }
        }
    }

    @ViewBuilder var ContinueButton: some View {
        FinalOnboardingButton(title: bottomButtonLabel) {
            if viewModel.wageAmount == nil {
                viewModel.showWageAmountSheet = true
            } else {
                viewModel.increaseStepNumberWithAnimation()
            }
        }
    }
}

#Preview {
    FinalOnboardingWageTypeAndAmount()
        .environmentObject(FinalWageViewModel())
}
