//
//  TodayPayoffGrid.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import SwiftUI
import Charts

// MARK: - TodayPayoffGrid

struct TodayPayoffGrid: View {
    @ObservedObject private var user: User = .main
    let shiftDuration: TimeInterval
    var willEarn: Double {
        user.getWage().perSecond * shiftDuration
    }

    let haveEarned: Double

    let initialPayoffs = User.main.getQueue().map { TempTodayPayoff(payoff: $0) }

    private var tempPayoffs: [TempTodayPayoff] {
        payOffExpenses(with: haveEarned, expenses: initialPayoffs).reversed()
    }

    var body: some View {
        LazyVGrid(columns: GridItem.flexibleItems(2)) {
            ForEach(tempPayoffs) { item in

                if item.progressAmount > 0.01 {
                    PayoffTodaySquare(item: item)
                        .pushLeft()
                }
            }
        }
    }
}

//struct TodayPayoffBarGraph: View {
//    @ObservedObject private var user: User = .main
//    let shiftDuration: TimeInterval
//    var willEarn: Double {
//        user.getWage().perSecond * shiftDuration
//    }
//
//    let haveEarned: Double
//
//    let initialPayoffs = User.main.getQueue().map { TempTodayPayoff(payoff: $0) }
//
//    private var tempPayoffs: [TempTodayPayoff] {
//
//            payOffExpenses(with: haveEarned, expenses: initialPayoffs).reversed()
//
//    }
//
//    var body: some View {
//        Chart(tempPayoffs) { item in
//            BarMark (
//                x:  .value("Amount", item.amountPaidOff),
//                y: .value("Type", item.type.rawValue.uppercased())
//            )
//
//
//
//        }
//        .chartXAxis(.hidden)
//        .chartYAxis(.hidden)
//        .chartForegroundStyleScale (
//            domain: tempPayoffs.compactMap({ item in item.type.rawValue }),
//            range: [Color.niceRed, Color.targetGray]
//
//        )
//    }
//}

// MARK: - TodayPayoffGrid_Previews

struct TodayPayoffGrid_Previews: PreviewProvider {
    static var previews: some View {
        TodayPayoffGrid(shiftDuration: 200 * 60 * 60, haveEarned: 400)
        
//        TodayPayoffBarGraph(shiftDuration: 200 * 60 * 60, haveEarned: 400)
//            .frame(height: 40)
//            .padding(.horizontal)
    }
}
