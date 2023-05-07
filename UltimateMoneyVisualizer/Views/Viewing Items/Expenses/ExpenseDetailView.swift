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

                    if let shift = alloc.shift {
                        ExpenseShiftRow(shift: shift, allocation: alloc)
                    }
                    
                    if let saved = alloc.savedItem {
                        ExpenseSavedRow(saved: saved, allocation: alloc)
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
        .onAppear {
//            let saved = user.getSaved().first!
//            print(saved.getTitle())
//            let amount = saved.getAmount() - 1
//            let alloc = Allocation(amount: amount, expense: expense, goal: nil, shift: nil, saved: saved, date: .now, context: user.managedObjectContext!)
//            let allocsForSaved = expense.getAllocations().filter({ $0.savedItem as? Saved != nil })
//            
//            allocsForSaved.forEach({ print($0.getItemTitle()) })
        }
    }
}

struct ExpenseShiftRow: View {
    
    let shift: Shift
    let allocation: Allocation
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main
    
    var body: some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.start.getFormattedDate(format: .abreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("SHIFT")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text(allocation.amount.formattedForMoney())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                Text(user.convertMoneyToTime(money: allocation.amount).formatForTime([.hour,.minute,.second]).uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 1)
    }
}

struct ExpenseSavedRow: View {
    
    let saved: Saved
    let allocation: Allocation
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main
    
    var body: some View {
        HStack {
            Image("green.background.pig")
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(8)
//                .foregroundColor(.white)
//
//                .background(settings.getDefaultGradient())
//                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(saved.getTitle())
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("SAVED")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text(allocation.amount.formattedForMoney())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                Text(user.convertMoneyToTime(money: allocation.amount).formatForTime([.hour,.minute,.second]).uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 1)
    }
}


// MARK: - ExpenseDetailView_Previews

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(expense: User.main.getExpenses().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
        
        ExpenseShiftRow(shift: User.main.getShifts().first!, allocation: User.main.getShifts().first!.getAllocations().first!)
            .environment(\.managedObjectContext, PersistenceController.context)
        
    }
}
