//
//  ExpenseDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - ExpenseDetailView

struct ExpenseDetailView: View {
    var expense: Expense

    var body: some View {
        VStack {
            Text(expense.title ?? "")
                .font(.largeTitle)
            Text("\(expense.amount)")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(expense.info ?? "")
                .font(.body)
        }
        .navigationTitle("Expense Detail")
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
        ExpenseDetailView(expense: expense)
    }
}
