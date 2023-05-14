//
//  ExpenseRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import SwiftUI

// MARK: - ExpenseRow

struct ExpenseRow: View {
    let expense: Expense
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(expense.titleStr)
                    .font(.headline)
                    .pushLeft()

                if !expense.isPassedDue {
                    Text("due in " + expense.timeRemaining.formatForTime([.year, .day, .hour, .minute, .second]))
                        .font(.caption2)
                } else {
                    Text("past due")
                        .font(.caption2)
                }

//                if let due = expense.dueDate
//                    {
//
//                    if due.timeIntervalSince(.now) > 0 {
//                        Text("due in " + expense.timeRemaining.formatForTime([.year, .day, .hour, .minute, .second]))
//                            .font(.caption2)
//                    }
//                    else {
//                        Text("past due")
//                            .font(.caption2)
//                    }
//
//                }
            }

            VStack(alignment: .leading, spacing: 5) {
                PayoffItemProgressBar(item: expense)
                    .frame(height: 10)
                Text(expense.amountPaidOff.formattedForMoney())
                    .font(.subheadline)
                    .spacedOut {
                        Text(expense.amountRemainingToPayOff.formattedForMoney())
                            .font(.subheadline)
                    }
            }
        }

        .allPartsTappable()
    }
}

// MARK: - ExpenseRow_Previews

struct ExpenseRow_Previews: PreviewProvider {
    static let expense: Expense = {
        do {
            let user = User.main
            let expense = Expense(title: "Car payment", info: nil, amount: 800, dueDate: .now.addDays(-1), user: user)
            let shift = try Shift(day: .friday, start: .nineAM.addDays(-1), end: .fivePM.addDays(-1), user: user, context: user.getContext())
            let alloc1 = try Allocation(amount: 100, expense: expense, goal: nil, shift: shift, saved: nil, date: .fivePM.addDays(-1), context: user.getContext())
            let saved = try Saved(amount: 490, title: "No new laptop", date: .now.addDays(-10), user: user, context: user.getContext())
            let alloc2 = try Allocation(amount: 459, expense: expense, saved: saved)

            return expense
        } catch {
            fatalError(String(describing: error))
        }

    }()

    static var previews: some View {
        ExpenseRow(expense: expense)
    }
}
