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
    
    let expense: Expense
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()
    @State private var showDeleteWarning = false
    @Environment(\.dismiss) private var dismiss

//    var filteredConts: [Contribution] {
//        model.allContributions.contributions.filter { $0.expense == expense }
//    }

    var body: some View {
        List {
            Text("Amount")
                .spacedOut(text: expense.amount.formattedForMoney())
            
            
            if let dueDate = expense.dueDate {
                Text("Due")
                    .spacedOut(text: dueDate.getFormattedDate(format: .abreviatedMonth))
            }
            

            Section("Progress") {
                
                Text("Due in")
                    .spacedOut(text: expense.timeRemaining.formatForTime([.day, .hour, .minute, .second]))
                
                Text("Paid off")
                    .spacedOut(text: expense.amountPaidOff.formattedForMoney())
                
                Text("Remaining to pay")
                    .spacedOut(text: expense.amountRemainingToPayOff.formattedForMoney())
                
            }

            Section("Insight") {
                
                Text("Time required to pay off")
                    .spacedOut(text: expense.totalTime.formatForTime())
                
                Text("Time remaining to pay off")
                    .spacedOut(text: expense.timeRemaining.formatForTime())
                
            }

            Section("Contributions") {
                
                ForEach(expense.getAllocations()) { alloc in
                    
                    Text(alloc.amount.formattedForMoney())
                    
                    
                }
                
             
            }

//            Spacer().listRowBackground(Color.clear).listRowSeparator(.hidden)
            Section {
                Button("Delete expense", role: .destructive) {
                    showDeleteWarning.toggle()
//                    model.allExpenses.removeExpense(expense)
                }
                .centerInParentView()
                .listRowBackground(Color.clear)
            }

            // TODO: Put a countdown to due date
        }

        .putInTemplate()
        .navigationTitle(expense.titleStr)
        .confirmationDialog("Delete expense", isPresented: $showDeleteWarning, titleVisibility: .visible, actions: {
            Button("Delete", role: .destructive) {
                
                
                guard let context = user.managedObjectContext else {
                    return
                }
                
                do {
                    context.delete(expense)
                    try context.save()
                }
                catch {
                    print("Failed to delete")
                }
                
                
                dismiss()
            }
        }, message: {
            Text("This action cannot be undone.")
        })
    }


    
    
}

// MARK: - ExpenseDetailView_Previews

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(expense: User.main.getExpenses().first!)
            .putInNavView(.inline)
    }
}
