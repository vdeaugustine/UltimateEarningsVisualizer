//
//  AssignAllocationView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import SwiftUI
import Vin

// MARK: - AssignAllocationForExpenseView

struct AssignAllocationForExpenseView: View {
    @State private var note: String = ""
    let expense: Expense
    @State private var sourceType: String = "shift"

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Shift.startDate, ascending: false)],
                  predicate: NSPredicate(format: "user == %@", User.main),
                  animation: .default)
    private var shifts: FetchedResults<Shift>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Saved.date, ascending: false)],
                  predicate: NSPredicate(format: "user == %@", User.main),
                  animation: .default)
    private var saved: FetchedResults<Saved>
    
    
//    User.main.getShifts().sorted { $0.start > $1.end }
    var body: some View {
        VStack {
            Picker("Source", selection: $sourceType) {
                Text("Shift").tag("shift")
                Text("Saved").tag("Saved")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Form {
                // MARK: - Show shifts

                if sourceType == "shift" {
                    ForEach(shifts) { shift in
                        Text(shift.start.getFormattedDate(format: .slashDate))
                            .spacedOut {
                                Text("\(shift.start.getFormattedDate(format: .minimalTime)) - \(shift.end.getFormattedDate(format: .minimalTime))")
                            }
                    }
                }

                // MARK: - Show Saved

                else {
                    ForEach(saved) { saved in
                            Text(saved.getTitle())
                                .spacedOut(text: saved.getAmount().formattedForMoney())
                        }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Choose source")
        .padding(.top)
    }
}

// MARK: - AssignAllocationForExpenseView_Previews

struct AssignAllocationForExpenseView_Previews: PreviewProvider {
//    static let expense: Expense = {
//        User.main.expenseWithMostAllocations() ?? .init(title: "Default", info: "Fallback", amount: 999, dueDate: .now.addDays(10), user: User.main)
//
//    }()

    static var previews: some View {
        AssignAllocationForExpenseView(expense: User.main.getExpenses().first!)
//            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
