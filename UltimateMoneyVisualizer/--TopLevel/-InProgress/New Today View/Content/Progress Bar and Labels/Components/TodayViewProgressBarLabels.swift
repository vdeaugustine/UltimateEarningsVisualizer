//
//  TodayViewProgressBarLabels.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayViewProgressBarLabels

struct TodayViewProgressBarLabels: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    var body: some View {
        HStack(spacing: 25) {
            makePill("Taxes",
                     amount: viewModel.taxesPaidSoFar.money(),
                     color: viewModel.taxesColor)
            if viewModel.showExpensesProgress {
                makePill("Expenses",
                         amount: viewModel.spentOnExpenses.money(),
                         color: viewModel.expensesColor)
            }
            if viewModel.showGoalsProgress {
                makePill("Goals",
                         amount: viewModel.spentOnGoals.money(),
                         color: viewModel.goalsColor)
            }

            if viewModel.showUnspent {
                makePill("Unspent",
                         amount: viewModel.unspent.money(),
                         color: viewModel.unspentColor)
            }
        }
    }

    func makePill(_ label: String, amount: String, color: Color) -> some View {
//        HStack {
            
            VStack(spacing: 0) {
                Circle()
                    .fill(color)
                    .foregroundStyle(color)
                    .frame(width: 10)
                Text(label)
                    .fontWeight(.bold)
                Text(amount)
                    .fontWeight(.regular)
            }
            .font(.lato(14))
            .fontWeight(.bold)
            .lineLimit(1)
//        }
//        .foregroundStyle(Color.white)
//        .padding(.vertical, 10)
//        .padding(.horizontal, 18)
//        .background {
//            Capsule(style: .circular)
//                .fill(color)
//        }
    }
}

// MARK: - TodayViewProgressBarLabels_Previews

struct TodayViewProgressBarLabels_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayViewProgressBarLabels()
                .environmentObject(TodayViewModel.main)
        }
    }
}
