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

    var body: some View {
        List {
            Text("Amount")
                .spacedOut(text: expense.amount.formattedForMoney())

            if let dueDate = expense.dueDate {
                Text("Due")
                    .spacedOut {
                        Text(dueDate.getFormattedDate(format: .abreviatedMonth))
                            .foregroundColor(expense.isPassedDue ? Color.red : Color.black)
                    }
            }

            Section("Progress") {
                Text("Due in")
                    .spacedOut {
                        Text(expense.timeRemaining.formatForTime([.day, .hour, .minute, .second]))
                            .foregroundColor(expense.isPassedDue ? Color.red : Color.black)
                    }

                Text("Paid off")
                    .spacedOut(text: expense.amountPaidOff.formattedForMoney())

                Text("Remaining to pay")
                    .spacedOut(text: expense.amountRemainingToPayOff.formattedForMoney())
            }

            Section("Insight") {
                Text("Time required to pay off")
                    .spacedOut(text: expense.totalTime.formatForTime([.day, .hour, .minute]))

                Text("Time remaining to pay off")
                    .spacedOut(text: expense.timeRemaining.formatForTime([.day, .hour, .minute]))
            }

            Section("Contributions") {
                if expense.amountRemainingToPayOff.roundTo(places: 2) >= 0.01 {
                    NavigationLink {
                        AddAllocationForExpenseView(expense: expense)
                    } label: {
                        Label("Add Another", systemImage: "plus")
                    }
                }

                ForEach(expense.getAllocations()) { alloc in

                    if let shift = alloc.shift {
                        AllocShiftRow(shift: shift, allocation: alloc)
                    }

                    if let saved = alloc.savedItem {
                        AllocSavedRow(saved: saved, allocation: alloc)
                    }
                }
            }

            Section {
                Button("Delete expense", role: .destructive) {
                    showDeleteWarning.toggle()
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
                } catch {
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
        ExpenseDetailView(expense: User.main.getExpenses().first { $0.amountRemainingToPayOff > 3 }!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
