//
//  FinalOnboardingWageWalkthroughSlide4.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/29/23.
//

import SwiftUI

struct FinalOnboardingWageAssumptions: View {
    let stepNumber: Double = 2
    let totalSteps: Double = 3

    @EnvironmentObject private var viewModel: FinalWageViewModel

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

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                VStack(spacing: 30) {
                    TitleAndContent(geo: geo)
                }
                .padding(.horizontal, widthScaler(24, geo: geo))

                Spacer()

                VStack(spacing: heightScaler(20, geo: geo)) {
                    Button("Reset to default", systemImage: "arrow.counterclockwise") {
                        viewModel.hoursPerDay = 8
                        viewModel.daysPerWeek = 5
                        viewModel.weeksPerYear = 50
                    }

                    ContinueButton
                        .padding(.horizontal, widthScaler(24, geo: geo))
                }

                .padding(.bottom)
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
        VStack(alignment: .leading, spacing: heightScaler(35, geo: geo)) {
            Text("Salary Calculation Assumptions")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            Text("This allows you to see your earnings breakdown by hour, minute, second, etc.")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(.secondary)

//            ScrollView {
            VStack(spacing: 25) {
                hoursPerDayRow
                daysPerWeekRow
                weeksPerYearRow
            }
//            }
        }
    }

    var hoursPerDayRow: some View {
        VStack {
            HStack {
                Text("Hours per day")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $viewModel.hoursPerDay) {
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
//        .padding()
    }

    var daysPerWeekRow: some View {
        VStack {
            HStack {
                Text("Days per week")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $viewModel.daysPerWeek) {
                    ForEach(stride(from: 1, to: 8, by: 1).map { Int($0) }, id: \.self) { num in

                        Text(num.str).tag(num)
                    }
                } label: {
                    Text("Days per week")
                        .font(.title3, design: .rounded)
                }
                .pickerStyle(.menu)
            }
        }
//        .padding()
    }

    var weeksPerYearRow: some View {
        VStack {
            HStack {
                Text("Weeks per year")
                    .font(.title3, design: .rounded)
                Spacer()
                Picker(selection: $viewModel.weeksPerYear) {
                    ForEach(stride(from: 1, to: 52, by: 1).map { Int($0) }, id: \.self) { num in

                        Text(num.str).tag(num)
                    }
                } label: {
                    Text("Weeks per year")
                        .font(.title3, design: .rounded)
                }
                .pickerStyle(.menu)
            }
        }
//        .padding()
    }

    var ContinueButton: some View {
        FinalOnboardingButton(title: "Finish") {
            viewModel.increaseStepNumberWithAnimation()
        }
    }
}

#Preview {
    FinalOnboardingWageAssumptions()
        .environmentObject(FinalWageViewModel())
}
