//
//  TodayPayoffGrid.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import SwiftUI

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

//    private var itemsAndAmounts: [(item: PayoffItem, amount: Double)] {
//        var retArr: [(item: PayoffItem, amount: Double)] = []
//
//        var allocated: Double = 0
//
//
//        for item in user.getQueue().shuffled() {
//            let available = willEarn - allocated
//            let price = item.amount
//            print(available, price)
//            if item.amountRemainingToPayOff <= available {
//                retArr.append((item: item, amount: item.amountRemainingToPayOff))
//                allocated += item.amountRemainingToPayOff
//            }
//            else {
//                retArr.append((item: item, amount: available))
//                allocated += available
//                break
//            }
//        }
//
    ////        if retArr.isEmpty,
    ////           let first = user.getQueue().first {
    ////            return [(item: first, amount: willEarn)]
    ////        }
//
//
//        return retArr
//    }

    var body: some View {
//        GeometryReader { geo in
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
