//
//  ExpenseRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import SwiftUI

struct ExpenseRow: View {
    
    let expense: Expense
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(expense.titleStr)
                    .font(.headline)
                    .pushLeft()

                if expense.dueDate != nil {
                    Text("due in " + expense.timeRemaining.formatForTime([.year, .hour, .minute, .second]))
                        .font(.subheadline)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                ProgressBar(percentage: expense.percentPaidOff, color: settings.themeColor)
                Text(expense.amountPaidOff.formattedForMoney())
                    .font(.subheadline)
                    .spacedOut {
                        Text(expense.amountRemainingToPayOff.formattedForMoney())
                            .font(.subheadline)
                    }
            }
        }

        .padding()
        .allPartsTappable()
    }
}

struct ExpenseRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(expense: User.main.getExpenses().first!)
    }
}
