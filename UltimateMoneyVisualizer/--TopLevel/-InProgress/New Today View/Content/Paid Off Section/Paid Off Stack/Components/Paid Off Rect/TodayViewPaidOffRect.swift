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

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.lato(.regular, 16))
                        .fontWeight(.black)

//                    VStack(spacing: 2) {
                    Text(item.amountPaidOff.money())
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .font(.lato(16))
                        .fontWeight(.bold)
                        .foregroundStyle(gradient)
//                                       .padding(5)
//                               }
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(item.progressAmount.money().replacingOccurrences(of: "$", with: "+"))
                        .font(.lato(.regular, 16))
                        .fontWeight(.black)

                    Text(item.amount.money())
                        .font(.lato(.regular, 12))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(uiColor: .gray))
                }
            }
            .padding(12, 20)
            .background(.white)
            .cornerRadius(15)
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
            Text(item.type.rawValue.uppercased())
                .font(.lato(.regular, 12))
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
