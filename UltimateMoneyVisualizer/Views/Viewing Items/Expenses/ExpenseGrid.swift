//
//  ExpenseGrid.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/8/23.
//

import SwiftUI
import Vin

// MARK: - ExpenseGrid

struct ExpenseGrid: View {
    @ObservedObject private var user = User.main
    
    var sortedExpenses: [Expense] {
        user.getExpenses().sorted(by: { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)})
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: GridItem.flexibleItems(2)) {
                ForEach(sortedExpenses) { expense in
                    NavigationLink {
                        ExpenseDetailView(expense: expense)
                    } label: {
                        ExpenseGridBlock(expense: expense, user: user)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            .padding()
        }
        .navigationTitle("Expenses")
        .putInTemplate()
    }
}

// MARK: - ExpenseGrid_Previews

struct ExpenseGrid_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseGrid()
            .putInNavView(.inline)
    }
}
