//
//  TodayViewDetailsSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/17/23.
//

import SwiftUI

// MARK: - TodayViewDetailsSection

struct TodayViewDetailsSection: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    var body: some View {
        VStack {
            HStack {
                TodayViewLabeledRect(symbolName: "hourglass.bottomhalf.filled",
                                     topText: viewModel.elapsedTime.breakDownTime(),
                                     bottomText: "Elapsed")
                TodayViewLabeledRect(symbolName: "hourglass",
                                     topText: viewModel.remainingTime.formatForTime([.hour, .minute, .second]),
                                     bottomText: "Remaining")
            }

            HStack {
                TodayViewLabeledRect(symbolName: "dollarsign",
                                     topText: viewModel.haveEarned.money(),
                                     bottomText: "Earned")
                TodayViewLabeledRect(symbolName: "dollarsign",
                                     topText: viewModel.willEarn.money(),
                                     bottomText: "Will Earn")
            }

            HStack {
                GPTPieChart(
                    pieChartData: [.init(color: .red,
                                         name: "Taxes",
                                         amount: viewModel.taxesPaidSoFar),
                                   .init(color: .googleBlueLabelBackground,
                                         name: "Expenses",
                                         amount: viewModel.spentOnExpenses),
                                   .init(color: .googleBlueLabelText,
                                         name: "Goals",
                                         amount: viewModel.spentOnGoals)]
                )
                
                VStack {
                    Text("HI")
                }
            }
        }
        .padding()
    }
}

// MARK: - TodayViewLabeledRect

struct TodayViewLabeledRect: View {
    let symbolName: String
    let topText: String
    let bottomText: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: symbolName)
                    .font(.system(size: 28))
                VStack(alignment: .leading, spacing: 4) {
                    Text(topText)
                        .font(.system(size: 24, weight: .bold))
                    Text(bottomText)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.gray)
                }
            }

            Spacer()
        }
        .padding()
        .frame(height: 128)
        .frame(maxWidth: 180)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray, lineWidth: 1.0)
        }
    }
}

// MARK: - TodayViewDetailsSection_Previews

struct TodayViewDetailsSection_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewDetailsSection()
            .environmentObject(TodayViewModel.main)
    }
}
