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

    @State private var shift: Shift? = nil

    @State private var saved: Saved? = nil

    @State private var showShiftSheet = false
    @State private var showSavedSheet = false

    @State private var allocAmount: Double = 0

    @ObservedObject var user = User.main
    @ObservedObject var settings = User.main.getSettings()

    var sourceIsNil: Bool {
        shift == nil && saved == nil
    }

    var sliderLimit: Double {
        if let shift {
            let minRem = min(expense.amountRemainingToPayOff, shift.totalAvailable)
            return max(0.01, minRem.roundTo(places: 2))
        }

        if let saved {
            let minRem = min(expense.amountRemainingToPayOff, saved.totalAvailable)
            return max(0.01, minRem.roundTo(places: 2))
        }

        return 0
    }

    var body: some View {
        Form {
            Section("Expense Amount") {
                Text("Total")
                    .spacedOut(text: expense.amountMoneyStr)
                Text("Remaining")
                    .spacedOut(text: expense.amountRemainingToPayOff.formattedForMoney())
            }

            Section("Choose Source") {
                Button("Shift") {
                    showShiftSheet = true
                }

                Button("Saved") {
                    showSavedSheet = true
                }
            }

            if let shift {
                Section("Source") {
                    ShiftRowForAllocSheet(shift: shift)
                }

                Section("Amount") {
                    Slider(value: $allocAmount, in: 0 ... sliderLimit, step: 0.01) {
                        Text("Amount")
                    } minimumValueLabel: {
                        Text(0.formattedForMoney())
                    } maximumValueLabel: {
                        Text(sliderLimit.formattedForMoney())
                    }
                }
            } else if let saved {
                Section("Source") {
                    SavedItemForAllocSheet(saved: saved, isAvailable: true)
                }

                Section("Amount") {
                    Slider(value: $allocAmount, in: 0 ... sliderLimit, step: 0.01) {
                        Text("Amount")
                    } minimumValueLabel: {
                        Text(0.formattedForMoney())
                    } maximumValueLabel: {
                        Text(sliderLimit.formattedForMoney())
                    }
                }

                Section {
                    Text("Allocate")
                        .spacedOut(text: allocAmount.formattedForMoney())

                    Button("Confirm") {
                    }
                }
            }
        }
        .onChange(of: shift) { newShift in

            print("Changed Shift")
            if newShift != nil {
                print("New shift")
                saved = nil
            }
        }
        .onChange(of: saved) { newSaved in
            print("Changed Saved")
            if newSaved != nil {
                print("New Saved")
                shift = nil
            }
        }
        .sheet(isPresented: $showShiftSheet, content: {
            ChooseShiftForAllocSheet(shift: $shift)
        })

        .sheet(isPresented: $showSavedSheet, content: {
            ChooseSavedForAllocSheet(saved: $saved)
        })
        .putInTemplate()
        .navigationTitle("Add Contribution")

        .bottomCapsule(label: "Save", gradient: settings.getDefaultGradient(), bool: !sourceIsNil) {
        }
    }
}

// MARK: - ChooseShiftForAllocSheet

struct ChooseShiftForAllocSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var shift: Shift?
    @ObservedObject private var user = User.main

    var shiftsToShow: [Shift] {
        user.getShifts().filter { $0.totalAvailable > 0.005 }
            .sorted {
                $0.totalAvailable > $1.totalAvailable
            }
    }

    var spentShifts: [Shift] {
        user.getShifts().filter { $0.totalAvailable <= 0.01 }
            .sorted {
                $0.totalAvailable > $1.totalAvailable
            }
    }

    @State private var showSpentShifts = false

    var body: some View {
        VStack(spacing: 0) {
            Toggle("Show spent shifts", isOn: $showSpentShifts)
                .padding()
                .background {
                    Color.listBackgroundColor
                }
                .fontWeight(.medium)

            List {
                if shiftsToShow.isEmpty {
                    Text("No shifts with available money")

                } else {
                    ForEach(shiftsToShow) { thisShift in

                        ShiftRowForAllocSheet(shift: thisShift)
                            .allPartsTappable()
                            .onTapGesture {
                                self.shift = thisShift
                                dismiss()
                            }
                    }
                }

                if showSpentShifts {
                    ForEach(spentShifts) { thisShift in
                        ShiftRowForAllocSheet(shift: thisShift)
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Shifts")
        .putInNavView(.inline)
    }
}

// MARK: - ChooseSavedForAllocSheet

struct ChooseSavedForAllocSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var saved: Saved?
    @ObservedObject private var user = User.main

    var savedsToShow: [Saved] {
        user.getSaved().filter { $0.totalAvailable > 0.005 }
            .sorted {
                $0.totalAvailable > $1.totalAvailable
            }
    }

    var spentSaveds: [Saved] {
        user.getSaved().filter { $0.totalAvailable <= 0.01 }
            .sorted {
                $0.totalAvailable > $1.totalAvailable
            }
    }

    @State private var showSpentSaved = false

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    Toggle("Show spent items", isOn: $showSpentSaved)
                }

                if savedsToShow.isEmpty {
                    Text("No saved items with available money")

                } else {
                    ForEach(savedsToShow) { thisSaved in

                        SavedItemForAllocSheet(saved: thisSaved, isAvailable: true)
                            .allPartsTappable()
                            .onTapGesture {
                                self.saved = thisSaved
                                dismiss()
                            }
                    }
                }

                if showSpentSaved {
                    ForEach(spentSaveds) { thisSaved in
                        SavedItemForAllocSheet(saved: thisSaved, isAvailable: false)
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Shifts")
        .putInNavView(.inline)
    }
}

// MARK: - SavedItemForAllocSheet

struct SavedItemForAllocSheet: View {
    let saved: Saved
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    let isAvailable: Bool

    var body: some View {
        HStack {
            Image("green.background.pig")
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(saved.getTitle())
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text(isAvailable ? "AVAILABLE" : "SPENT")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text(saved.totalAvailable.formattedForMoney())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
//                Text("AVAILABLE")
//                    .font(.caption2)
//                    .fontWeight(.medium)
//                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 1)
    }
}

// MARK: - ShiftRowForAllocSheet

struct ShiftRowForAllocSheet: View {
    let shift: Shift
    @ObservedObject private var settings = User.main.getSettings()

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

                Text("Spent: \(shift.totalAllocated.formattedForMoney())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("\(shift.totalAvailable.formattedForMoney())")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                Text("Available")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - AssignAllocationForExpenseView_Previews

struct AssignAllocationForExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AssignAllocationForExpenseView(expense: User.main.getExpenses().last!)
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .tint(Color.red)

        ChooseShiftForAllocSheet(shift: .constant(User.main.getShifts()[4]))
            .putInNavView(.inline)
    }
}
