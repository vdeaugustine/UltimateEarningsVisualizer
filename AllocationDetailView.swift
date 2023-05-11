//
//  AllocationDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/11/23.
//

import SwiftUI

// MARK: - AllocationDetailView

struct AllocationDetailView: View {
    /**
      Function that formats a `Double` value to a string with a specified number of decimal points.

      - Parameters:
         - value: The `Double` value to format.
         - decimalPoints: The number of decimal points to keep in the resulting string.
         - includeLeadingZero: A `Bool` that determines whether to include a leading zero for values between 0 and 1.

      - Returns: A string representation of the `Double` value, rounded to the specified number of decimal points. If there was an error during formatting, it returns the string "Error formatting number".

      # Example #
     print(formatDouble(value: 0.123456789, decimalPoints: 2, includeLeadingZero: true)) // "0.12"
     print(formatDouble(value: 123.456789, decimalPoints: 3, includeLeadingZero: true)) // "123.457"

     */
    func formatDouble(value: Double, decimalPoints: Int, includeLeadingZero: Bool) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = decimalPoints
        numberFormatter.maximumFractionDigits = decimalPoints
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.alwaysShowsDecimalSeparator = decimalPoints > 0
        numberFormatter.minimumIntegerDigits = includeLeadingZero ? 1 : 0

        if let formattedNumberString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedNumberString
        } else {
            return "Error formatting number"
        }
    }

    let allocation: Allocation
    @ObservedObject private var user = User.main

    var spentOnHeaderStr: String {
        if allocation.expense != nil {
            return "Expense"
        }
        if allocation.goal != nil {
            return "Goal"
        }
        return "Spent"
    }

    var sourceTypeString: String {
        if allocation.shift != nil {
            return "Shift"
        } else if allocation.savedItem != nil {
            return "Saved"
        }

        return ""
    }

    var amountPercent: Double {
        let decimal: Double
        if let goal = allocation.goal {
            decimal = allocation.amount / goal.amount
        } else if let expense = allocation.expense {
            decimal = allocation.amount / expense.amount
        } else {
            decimal = 0
        }

        return decimal * 100
    }

    var body: some View {
        List {
            Section("Source") {
                if let saved = allocation.savedItem {
                }
                if let shift = allocation.shift {
                    NavigationLink {
                        ShiftDetailView(shift: shift)
                    } label: {
                        HStack {
                            Text("Shift for " + shift.start.getFormattedDate(format: .abreviatedMonth))
                            Spacer()

                            Text(shift.totalEarned.formattedForMoney())
                                .fontWeight(.bold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                    }
                }
            }

            Section(spentOnHeaderStr) {
                if let goal = allocation.goal {
                    GoalRow(goal: goal)
                }
                if let expense = allocation.expense {
                    NavigationLink {
                        ExpenseDetailView(expense: expense)

                    } label: {
                        VStack {
                            Text(expense.titleStr)
                                .spacedOut {
                                    Text(expense.amount.formattedForMoney())
                                        .fontWeight(.bold)
                                        .foregroundStyle(user.getSettings().getDefaultGradient())
                                }
                        }
                    }
                }
            }

            Section("Amount") {
                Text("Allocation total")
                    .spacedOut {
                        VStack(alignment: .trailing) {
                            Text(allocation.amount.formattedForMoney())
                                .fontWeight(.bold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())

                            Text(formatDouble(value: amountPercent, decimalPoints: 2, includeLeadingZero: true) + "%")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.gray.getGradient())
                        }
                    }
            }
        }
        .listStyle(.insetGrouped)
        .bottomButton(label: "Delete", gradient: Color.niceRed.getGradient()) {
        }
        .putInTemplate()
        .navigationTitle("Allocation Details")
    }
}

// MARK: - AllocationDetailView_Previews

struct AllocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AllocationDetailView(allocation: User.main.getExpenses().first(where: { $0.getAllocations().isEmpty == false })!.getAllocations().first!)
            .putInNavView(.inline)
    }
}
