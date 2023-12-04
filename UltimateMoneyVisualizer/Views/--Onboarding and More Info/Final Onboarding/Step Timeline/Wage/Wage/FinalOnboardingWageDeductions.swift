//
//  FinalOnboardingWalkthroughSlide3.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/29/23.
//

import SwiftUI

struct FinalOnboardingWageDeductions: View {
    @EnvironmentObject private var viewModel: FinalWageViewModel

    @State private var amount: String = ""

    func formatAsCurrency(string: String) -> String {
        let numericString = string.filter("0123456789".contains)
        let intValue = Int(numericString) ?? 0
        let dollars = Double(intValue) / 100.0

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        return formatter.string(from: NSNumber(value: dollars)) ?? "$0.00"
    }

    var showingAmount: String {
        formatAsCurrency(string: amount)
    }

    var keys: [Key] {
        (1 ... 9).map { num in Key(label: "\(num)", action: {
            if amount.count < 10 { amount += "\(num)" }
        }

        , isNumber: true) } +
            // Non-numbers
            [Key(label: "multiply", action: { amount = "" }, isNumber: false),
             Key(label: "0", action: { amount += "0" }, isNumber: true),
             Key(label: "delete.left", action: {
                 if !amount.isEmpty {
                     amount.removeLast()
                 }

             }, isNumber: false)]
    }

    // MARK: - 
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                VStack(spacing: 30) {
                    TitleAndContent(geo: geo)
                }
                .padding(.horizontal, widthScaler(24, geo: geo))

                Spacer()

                VStack(spacing: heightScaler(65, geo: geo)) {
                    VStack(spacing: heightScaler(20, geo: geo)) {
                        ContinueButton
                            .padding(.horizontal, widthScaler(24, geo: geo))
                    }
                }
            }
        }
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

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(30, geo: geo)) {
            Text("Taxes and Deductions")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            Text("By entering your tax details, the app can precisely calculate and incorporate your taxes. This ensures that the displayed take-home pay accurately reflects your real earnings for each paycheck.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)

            VStack {
                stateTaxRow
                VStack(spacing: 3) {
                    federalTaxRow
                }
            }
        }
    }

    var stateTaxRow: some View {
        VStack {
            Toggle(isOn: $viewModel.includeStateTaxes) {
                Text("State Tax")
                    .font(.title3, design: .rounded)
            }
            .tint(Color.accentColor)

            if viewModel.includeStateTaxes {
                Text("\(viewModel.stateTaxAmount.simpleStr())%")
                    .font(.title, design: .rounded, weight: .semibold)

                Divider()

                Menu("Edit") {
                    Button("Enter manually", systemImage: "square.and.pencil") {
                    }

                    Button("Calculate for me", systemImage: "percent") {
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 7)
            }
        }
        .padding()
        .background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(0.35)
        }
    }

    var federalTaxRow: some View {
        VStack {
            Toggle(isOn: $viewModel.includeFederalTaxes) {
                Text("Federal Tax")
                    .font(.title3, design: .rounded)
            }
            .tint(Color.accentColor)

            if viewModel.includeFederalTaxes {
                Text("\(viewModel.federalTaxAmount.simpleStr())%")
                    .font(.title, design: .rounded, weight: .semibold)

                Divider()

                Menu("Edit") {
                    Button("Enter manually", systemImage: "square.and.pencil") {
                    }

                    Button("Calculate for me", systemImage: "percent") {
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 7)
            }
        }
        .padding()
        .background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(0.35)
//                .shadow(radius: 10)
        }
    }

    var ContinueButton: some View {
        FinalOnboardingButton(title: "Continue") {
            viewModel.increaseStepNumberWithAnimation()
        }
    }
}

#Preview {
    FinalOnboardingWageDeductions()
        .environmentObject(FinalWageViewModel())
}
