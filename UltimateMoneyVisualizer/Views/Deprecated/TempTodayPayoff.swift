//
//  TempTodayPayoff.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import Foundation

// MARK: - TempTodayPayoff

struct TempTodayPayoff: Identifiable, Equatable {
    var amount: Double
    let initialAmountPaidOff: Double
    var amountPaidOff: Double
    var amountRemaining: Double { amount - amountPaidOff }
    var progressAmount: Double { amountPaidOff - initialAmountPaidOff }
    var title: String
    let id: UUID
    let type: PayoffType

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.amountPaidOff == rhs.amountPaidOff
    }

    init(expense: Expense) {
        self.amount = expense.amount
        self.amountPaidOff = expense.amountPaidOff
        self.initialAmountPaidOff = expense.amountPaidOff
        self.title = expense.titleStr
        self.id = expense.getID()
        self.type = .expense
    }

    init(goal: Goal) {
        self.amount = goal.amount
        self.amountPaidOff = goal.amountPaidOff
        self.initialAmountPaidOff = goal.amountPaidOff
        self.title = goal.titleStr
        self.id = goal.getID()
        self.type = .goal
    }

    init(amount: Double, amountPaidOff: Double, title: String, id: UUID) {
        self.amount = amount
        self.amountPaidOff = amountPaidOff
        self.initialAmountPaidOff = amountPaidOff
        self.id = id
        self.title = title
        self.type = .expense
    }

    init(payoff: PayoffItem) {
        self.amount = payoff.amount
        self.amountPaidOff = payoff.amountPaidOff
        self.initialAmountPaidOff = payoff.amountPaidOff
        self.title = payoff.titleStr
        self.id = payoff.getID()
        self.type = .init(payoff)
    }
}

func payOffExpenses(with amount: Double, expenses: [TempTodayPayoff]) -> [TempTodayPayoff] {
    var newExp: [TempTodayPayoff] = []
    var remainingAmount = amount

    for expense in expenses {
        var thisExp = expense
        let amountToPayOff = min(remainingAmount, expense.amountRemaining)
        thisExp.amountPaidOff += amountToPayOff
        remainingAmount -= amountToPayOff
        newExp.append(thisExp)

        if remainingAmount <= 0 {
            let countDifference = expenses.count - newExp.count
            if countDifference != 0 {
                newExp += expenses.suffixArray(countDifference)
            }
            break
        }
    }

    return newExp
}
