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
    @FetchRequest(entity: Expense.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Expense.dateCreated, ascending: false)]) private var expenses: FetchedResults<Expense>

    var body: some View {
        List {
            ForEach(expenses, id: \.self) { expense in
                NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                    VStack(alignment: .leading) {
                        Text(expense.title ?? "")
                            .font(.headline)
                        Text("\(expense.amount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Expenses")
    }
}

// MARK: - ExpenseListView_Previews

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
