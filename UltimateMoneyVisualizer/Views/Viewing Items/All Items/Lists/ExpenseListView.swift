//
//  ExpenseListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - ExpenseListView

struct ExpenseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main

    @State private var showPassedDue = true
    @State private var showSearch = false
    @State private var searchText: String = ""

    var expensesToShow: [Expense] {
        var expenses = user.getExpenses()

        if !showPassedDue {
            expenses.removeAll(where: { $0.isPassedDue })
        }

        return expenses
    }

    var body: some View {
        List {
            Section {
                Toggle("Show passed due expenses", isOn: $showPassedDue)
            }

            ForEach(expensesToShow, id: \.self) { expense in
                NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                    ExpenseRow(expense: expense)
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Expenses")
        .toolbarAdd {
            CreateExpenseView()
        }
    }
}

// MARK: - ExpenseListView_Previews

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInTemplate()
            .putInNavView(.inline)
    }
}
