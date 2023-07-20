//
//  TodayProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayProgressBar: View {
    @ObservedObject var viewModel: TodayViewModel
    let barHeights: CGFloat = 16

    var body: some View {
        ZStack {
            ProgressBar(percentage: viewModel.todayShiftPercentCompleted,
                        height: barHeights,
                        color: viewModel.settings.themeColor)

            // MARK: Taxes

            if viewModel.wage.includeTaxes {
                ProgressBar(percentage: viewModel.wage.totalTaxMultiplier,
                            height: barHeights,
                            color: viewModel.taxesColor.opacity(0.5),
                            showBackgroundBar: false)

                ProgressBar(percentage: min(viewModel.todayShiftPercentCompleted,
                                            viewModel.wage.totalTaxMultiplier),
                            height: barHeights,
                            color: viewModel.taxesColor,
                            showBackgroundBar: false)
            }

            // MARK: Expenses

            ProgressBar(percentage: viewModel.percentForExpenses,
                        height: barHeights,
                        color: viewModel.expensesColor,
                        showBackgroundBar: false)
            
            // MARK: Goals
            ProgressBar(percentage: viewModel.percentForGoals,
                        height: barHeights,
                        color: viewModel.goalsColor,
                        showBackgroundBar: false)
            
            // MARK: Unspent
            ProgressBar(percentage: 1 - viewModel.percentPaidSoFar,
                        height: barHeights,
                        color: viewModel.unspentColor,
                        showBackgroundBar: false)
        }
        .padding(16)
        .background {
            Color.white
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 4)
        }
        .frame(height: 60)
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayProgressBar(viewModel: .main)
            .padding()
    }
}
