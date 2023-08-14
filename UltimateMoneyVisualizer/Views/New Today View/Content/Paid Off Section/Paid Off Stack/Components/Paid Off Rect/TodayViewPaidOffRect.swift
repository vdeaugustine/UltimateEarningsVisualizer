//
//  TodayViewPaidOffRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayViewPaidOffRect

struct TodayViewPaidOffRect: View {
    let item: TempTodayPayoff
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        TodayPaidOffRectContainer {
            HStack {
                progressCircle
                titleAndTotalPaidOff
                Spacer()
                progressAndTotal
            }
            .padding(12, 20)
            .background(.white)
            .cornerRadius(15)
        }
        .onTapGesture {
            switch item.type {
                case .goal:
                    if let goal = item.getPayoffItem(user: viewModel.user) as? Goal {
                        viewModel.navManager.todayViewNavPath.append(NavManager.TodayViewDestinations.goalDetail(goal))
                    }

                case .expense:
                    if let expense = item.getPayoffItem(user: viewModel.user) as? Expense {
                        viewModel.navManager.todayViewNavPath.append(NavManager.TodayViewDestinations.expenseDetail(expense))
                    }
                case .tax:
                    break
            }
        }
    }

    var gradient: LinearGradient {
        switch item.type {
            case .goal:
                return viewModel.goalsColor.getGradient()
            case .expense:
                return viewModel.expensesColor.getGradient()
            case .tax:
                return viewModel.taxesColor.getGradient()
        }
    }

    var progressCircle: some View {
        ProgressCircle(percent: item.amountPaidOff / item.amount,
                       widthHeight: 64,
                       gradient: gradient,
                       lineWidth: 5,
                       showCheckWhenComplete: false) {
            Text(item.type.titleForProgressCircle)
                .format(size: 12, weight: .bold)
                .lineLimit(1)

                .foregroundStyle(Color(uiColor: .gray))
        }
    }

    var titleAndTotalPaidOff: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(.lato(.regular, 16))
                .fontWeight(.black)

            Text(item.amountPaidOff.money())
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .font(.system(size: 16))
                .fontWeight(.bold)
        }
    }

    var progressAndTotal: some View {
        VStack(spacing: 4) {
            Text(item.progressAmount.money().replacingOccurrences(of: "$", with: "+"))
                .font(.system(size: 16))
                .fontWeight(.black)
                .foregroundStyle(gradient)

            Text(item.amount.money())
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundStyle(Color(uiColor: .gray))
        }
    }
}

// MARK: - TodayViewPaidOffRect_Previews

struct TodayViewPaidOffRect_Previews: PreviewProvider {
    static let tempPayoff: TempTodayPayoff = {
        TempTodayPayoff(amount: 119.21,
                        amountPaidOff: 117.77,
                        title: "Testing this item",
                        type: .expense,
                        id: .init())
    }()

    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayViewPaidOffRect(item: .init(payoff: User.main.getQueue().first!))
                .environmentObject(TodayViewModel.main)
        }
    }
}
