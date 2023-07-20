//
//  TodayViewPaidOffRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

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

                    Text(item.type.rawValue.uppercased())
                        .font(.lato(.regular, 12))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(uiColor: .gray))
                }

                Spacer()

                VStack(spacing: 4) {
                    Text(item.progressAmount.formattedForMoney().replacingOccurrences(of: "$", with: "+"))
                        .font(.lato(.regular, 16))
                        .fontWeight(.black)

                    Text(item.amount.formattedForMoney())
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
            VStack(spacing: 2) {
                Text(item.amountPaidOff.formattedForMoney())
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .font(.lato(16))
                    .fontWeight(.bold)
                    .foregroundStyle(gradient)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayViewPaidOffRect(item: .init(payoff: User.main.getQueue().first!))
            .environmentObject(TodayViewModel.main)
    }
}
