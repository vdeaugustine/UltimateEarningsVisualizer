//
//  TodayPaidOffStack.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayPaidOffStack

struct TodayPaidOffStack: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    
    var items: [TempTodayPayoff] {
        let goals = viewModel.user.getGoals()
            .compactMap({TempTodayPayoff(payoff: $0)})
        let expenses = viewModel.user.getExpenses()
            .compactMap({TempTodayPayoff(payoff: $0)})
        let union: [TempTodayPayoff] = (goals + expenses).filter({ $0.progressAmount > 0.01 })
        return union.sorted(by: {$0.queueSpot < $1.queueSpot })
    }

    var body: some View {
        LazyVStack {
            if viewModel.paidOffStackIsExpanded {
                ForEach(items) { item in
                    TodayViewPaidOffRect(item: item)
                }
            } else {
                if let firstItem = items.first {
                    TodayViewPaidOffRect(item: firstItem)
                }
            }
        }
    }
}

// MARK: - TodayPaidOffStack_Previews

struct TodayPaidOffStack_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayPaidOffStack()
        }
        .environmentObject(TodayViewModel(user: .testing))
    }
}
