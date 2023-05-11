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
    var body: some View {
        List {
            ForEach(User.main.getExpenses(), id: \.self) { expense in
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
