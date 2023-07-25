//
//  GoalDetailTotalAmount.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/12/23.
//

import SwiftUI

// MARK: - GoalDetailTotalAmount

struct GoalDetailTotalAmount: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.goal.amountMoneyStr)
                    .font(.title)
                    .boldNumber()

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text("Total Amount")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    Text(viewModel.user.convertMoneyToTime(money: viewModel.goal.amount).breakDownTime())
                    Spacer()
//                    Text("work time")
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .layoutPriority(1)
                .minimumScaleFactor(0.85)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(height: 120)
    }
}

// MARK: - GoalDetailTotalAmount_Previews

struct GoalDetailTotalAmount_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackgroundColor
            GoalDetailTotalAmount(viewModel: GoalDetailViewModel(goal: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
        }
        .ignoresSafeArea()
    }
}
