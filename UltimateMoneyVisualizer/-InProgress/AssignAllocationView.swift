//
//  AssignAllocationView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import SwiftUI

// MARK: - AssignAllocationForExpenseView

struct AssignAllocationForExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var note: String = ""
    let expense: Expense
    @State private var sourceType: String = "shift"

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
                    ForEach(User.main.getShifts().sorted(by: { $0.start > $1.start })) { shift in
                        Text(shift.start.getFormattedDate(format: .slashDate))
                            .spacedOut {
                                Text("\(shift.start.getFormattedDate(format: .minimalTime)) - \(shift.end.getFormattedDate(format: .minimalTime))")
                            }
                    }
                }

                // MARK: - Show Saved

                else {
                    ForEach(User.main.getSaved().sorted(by: { $0.getDate() > $1.getDate() })) { saved in

                        Text(saved.getTitle())
                            .spacedOut(text: saved.getAmount().formattedForMoney())
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Choose source")
    }
}

// MARK: - AssignAllocationForExpenseView_Previews

struct AssignAllocationForExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AssignAllocationForExpenseView(expense: User.main.getExpenses().first!)
    }
}
