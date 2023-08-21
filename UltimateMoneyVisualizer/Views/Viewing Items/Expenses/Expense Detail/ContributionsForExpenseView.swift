//
//  ContributionsForExpenseView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import SwiftUI

struct ContributionsForExpenseView: View {
    let expense: Expense
    var body: some View {
        List {
            Section("Progress") {
                Text("Total cost")
                    .spacedOut(text: expense.amountMoneyStr)
                Text("Paid off")
                    .spacedOut(text: expense.amountPaidOff.money())
            }

            Section("Shifts") {
                Text("Paid off by shifts")
                    .spacedOut(text: expense.amountPaidByShifts.money())

                ForEach(expense.getAllocations()) { alloc in
                    if let shift = alloc.shift {
                        HStack {
                            Text(shift.start.getFormattedDate(format: .abbreviatedMonth))
                            Spacer()
                            Text(alloc.amount.money())
                        }
                    }
                    
                }
            }
            
            Section("Saved items") {
                Text("Paid off by saving")
                    .spacedOut(text: expense.amountPaidBySaved.money())
                
                ForEach(expense.getAllocations()) { alloc in
                    if let saved = alloc.savedItem {
                        HStack {
                            Text(saved.getTitle())
                            Spacer()
                            Text(alloc.amount.money())
                        }
                    }
                    
                }
            }
        }
        .navigationTitle("Contributions")
        .putInTemplate()
    }
}

#Preview {
    ContributionsForExpenseView(expense: User.main.getExpenses().first!)
}
