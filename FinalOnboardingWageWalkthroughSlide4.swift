//
//  FinalOnboardingWageWalkthroughSlide4.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/29/23.
//

import SwiftUI

struct FinalOnboardingWageWalkthroughSlide4: View {
    @State private var amount: String = ""
    @State private var textFieldIsFocused = true
    @State private var textFieldFrame: CGRect = .zero
    @State private var tapLocation: CGPoint = .zero

    let stepNumber: Double = 2
    let totalSteps: Double = 3

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

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                VStack(spacing: 30) {
                    Progress

                    TitleAndContent(geo: geo)
                }
                .padding(.horizontal, widthScaler(24, geo: geo))

                Spacer()

                VStack(spacing: heightScaler(65, geo: geo)) {
                    VStack(spacing: heightScaler(20, geo: geo)) {
                        
                        Button("Reset to default") {
                            
                        }
                        
                        ContinueButton
                            .padding(.horizontal, widthScaler(24, geo: geo))
                    }
                }
            }
        }

        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: stepNumber / totalSteps,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP \(Int(stepNumber)) OF 3")
                .font(.system(.title3, design: .rounded))
        }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(30, geo: geo)) {
            Text("Salary Calculation Assumptions")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            Text("This allows you to see your earnings breakdown by hour, minute, second, etc.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)

            ScrollView {
                VStack {
                    hoursPerDayRow
                    daysPerWeekRow
                    weeksPerYearRow
                }
            }
        }
    }

    @State private var includeStateTaxes = false
    @State private var stateTaxAmount: Double = 7
    @State private var hoursPerDay: Double = 7
    @State private var daysPerWeek: Int = 5
    @State private var weeksPerYear: Int = 50

    var hoursPerDayRow: some View {
        VStack {
            HStack {
                Text("Hours per day")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $hoursPerDay) {
                    ForEach(Array(stride(from: 0.5, to: 24, by: 0.5)), id: \.self) { num in
                        
                        Text(num.simpleStr(1)).tag(num)
                        
                    }
                } label: {
                    Text("Hours per day")
                        .font(.title3, design: .rounded)
                }
                .pickerStyle(.menu)
            }
            

        }
        .padding()
//        .background {
//            Color.white
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .opacity(0.35)
//        }
    }
    
    
    var daysPerWeekRow: some View {
        VStack {
            HStack {
                Text("Days per week")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $daysPerWeek) {
                    ForEach(stride(from: 1, to: 8, by: 1).map({ Int($0) }), id: \.self) { num in
                        
                        Text(num.str).tag(num)
                        
                    }
                } label: {
                    Text("Days per week")
                        .font(.title3, design: .rounded)
                }
                .pickerStyle(.menu)
            }
            

        }
        .padding()
    }

    var weeksPerYearRow: some View {
        VStack {
            HStack {
                Text("Weeks per year")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $weeksPerYear) {
                    ForEach(stride(from: 1, to: 52, by: 1).map({ Int($0) }), id: \.self) { num in
                        
                        Text(num.str).tag(num)
                        
                    }
                } label: {
                    Text("Weeks per year")
                        .font(.title3, design: .rounded)
                }
                .pickerStyle(.menu)
            }
            

        }
        .padding()
    }

    var ContinueButton: some View {
        Button {
        } label: {
            Text("Continue")
                .font(.system(.headline, design: .rounded, weight: .regular))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.accentColor
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
    }
}

#Preview {
    FinalOnboardingWageWalkthroughSlide4()
}
