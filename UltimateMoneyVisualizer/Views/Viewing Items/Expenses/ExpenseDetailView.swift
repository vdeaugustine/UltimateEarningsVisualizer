//
//  ExpenseDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI
import Vin

// MARK: - ExpenseDetailView

struct ExpenseDetailView: View {
    var expense: Expense

    var body: some View {
        List {
            Text("Amount")
                .spacedOut(text: expense.amountMoneyStr)

            if let info = expense.info {
                Text(info)
            }

            
            if let dateCreated = expense.dateCreated {
                Text("Date created")
                    .spacedOut(text: dateCreated.getFormattedDate(format: .slashDate) )

                if let dueDate = expense.dueDate {
                    Text("Due date")
                        .spacedOut(text: dueDate.getFormattedDate(format: .slashDate))
                    
                    Text("Total time")
                        .spacedOut(text: expense.totalTime.formatForTime([.day, .hour, .minute, .second]))
                    
                    Text("Time remaining")
                        .spacedOut(text: expense.timeRemaining.formatForTime([.day, .hour, .minute, .second]))
                }
            }
            
            

            Section {
                Text("Amount paid off")
                    .spacedOut(text: expense.amountPaidOff.formattedForMoney())
                
                NavigationLink {
                    AssignAllocationForExpenseView(expense: expense)
                } label: {
                    Text("Allocate money")
                }
            }
        }
        .navigationTitle(expense.titleStr)
    }
}

// MARK: - ExpenseDetailView_Previews

struct ExpenseDetailView_Previews: PreviewProvider {
    static let context = PersistenceController.context

    static let expense: Expense = {
        let expense = Expense(context: context)

        expense.title = "Test expense"
        expense.amount = 39.21
        expense.info = "this is a test description"
        expense.dateCreated = Date()

        return expense
    }()

    static var previews: some View {
        ExpenseDetailView(expense: User.main.getExpenses().first!)
            .putInNavView(.inline)
    }
}
