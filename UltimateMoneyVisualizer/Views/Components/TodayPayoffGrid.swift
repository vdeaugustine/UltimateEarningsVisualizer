//
//  TodayPayoffGrid.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import Charts
import SwiftUI

// MARK: - TodayPayoffGrid

struct TodayPayoffGrid: View {
    @ObservedObject private var user: User = .main
    let shiftDuration: TimeInterval
    var willEarn: Double {
        user.getWage().perSecond * shiftDuration
    }

    let haveEarned: Double

    let initialPayoffs = User.main.getQueue().map { TempTodayPayoff(payoff: $0)
    }

    private var tempPayoffs: [TempTodayPayoff] {
        var expenses: [TempTodayPayoff] = []
        let wage = user.getWage()
        if wage.includeTaxes {
            if wage.stateTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.stateTaxPercentage,
                          amountPaidOff: 0,
                          title: "State Tax",
                          id: .init())
                )
            }
            if wage.federalTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.federalTaxPercentage,
                          amountPaidOff: 0,
                          title: "Federal Tax",
                          id: .init())
                )
            }
        }

        let expensesToPay = expenses + initialPayoffs
        return payOffExpenses(with: haveEarned, expenses: expensesToPay).reversed()
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

// MARK: - TodayPayoffGrid_Previews

struct TodayPayoffGrid_Previews: PreviewProvider {
    static var previews: some View {
        TodayPayoffGrid(shiftDuration: 200 * 60 * 60, haveEarned: 400)
    }
}
