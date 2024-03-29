//
//  AssignAllocationView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - AssignAllocationToPayoffView

struct AssignAllocationToPayoffView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let payoffItem: PayoffItem

    // swiftformat:sort:begin
    @State private var allocAmount: Double = 0
    @State private var note: String = ""
    @State private var saved: Saved? = nil
    @State private var shift: Shift? = nil
    @State private var showAlert = false
    @State private var showSavedSheet = false
    @State private var showShiftSheet = false
    @State private var sourceType: String = "shift"
    @State private var toastConfiguration: AlertToast = AlertToast(type: .regular)
    // swiftformat:sort:end

    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main

    var sourceIsNil: Bool {
        shift == nil && saved == nil
    }

    var sliderLimit: Double {
        if let shift {
            let minRem = min(payoffItem.amountRemainingToPayOff, shift.totalAvailable)
            return max(0.01, minRem.roundTo(places: 2))
        }

        if let saved {
            let minRem = min(payoffItem.amountRemainingToPayOff, saved.totalAvailable)
            return max(0.01, minRem.roundTo(places: 2))
        }

        return 0
    }

    var body: some View {
        Form {
            Section("Expense Amount") {
                Text("Total")
                    .spacedOut(text: payoffItem.amountMoneyStr)
                Text("Remaining")
                    .spacedOut(text: payoffItem.amountRemainingToPayOff.money())
            }

            Section("Choose Source") {
                Button("Shift") {
                    showShiftSheet = true
                }

                Button("Saved") {
                    showSavedSheet = true
                }
            }

            Section {
                if let shift {
                    ShiftRowForAllocSheet(shift: shift)
                } else if let saved {
                    SavedItemForAllocSheet(saved: saved, isAvailable: true)
                    Text("Amount chosen")
                        .spacedOut(text: allocAmount.money())
                }
            } header: {
                if shift != nil || saved != nil {
                    Text("Source")
                } else {
                    Text("").hidden()
                }
            }

            if sliderLimit > 0 {
                Section("Choose Amount") {
                    Slider(value: $allocAmount, in: 0 ... max(sliderLimit, 0), step: 0.01) {
                        Text("Amount")
                    } minimumValueLabel: {
                        Text(0.money())
                    } maximumValueLabel: {
                        Text(sliderLimit.money())
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .onChange(of: shift) { newShift in

            if newShift != nil {
                saved = nil
            }
        }
        .onChange(of: saved) { newSaved in
            if newSaved != nil {
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

        .bottomCapsule(label: "Save", gradient: settings.getDefaultGradient(), bool: !sourceIsNil, bottomPadding: 10) {
            do {
                if let expense = payoffItem as? Expense {
                    try Allocation(amount: allocAmount, expense: expense, goal: nil, shift: shift, saved: saved, date: .now, context: viewContext)
                }

                if let goal = payoffItem as? Goal {
                    try Allocation(amount: allocAmount, expense: nil, goal: goal, shift: shift, saved: saved, date: .now, context: viewContext)
                }

                toastConfiguration = AlertToast(displayMode: .alert, type: .complete(settings.themeColor), title: "Saved successfully")
                showAlert = true
            } catch {
                print(error)
                toastConfiguration = AlertToast(displayMode: .alert, type: .error(settings.themeColor), title: "Failed to save")
                showAlert = true
            }
        }

        .toast(isPresenting: $showAlert,
               duration: 2,
               tapToDismiss: false,
               offsetY: 40,
               alert: {
                   toastConfiguration
               })
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
        List {
            if shiftsToShow.isEmpty {
                Section {
                    Text("No shifts with available money")
                } header: {
                    Text("Empty").hidden()
                }

            } else {
                Section {
                    Toggle("Show spent shifts", isOn: $showSpentShifts)
                } header: {
                    Text("Show Shifts").hidden()
                }

                Section {
                    ForEach(shiftsToShow) { thisShift in

                        ShiftRowForAllocSheet(shift: thisShift)
                            .allPartsTappable()
                            .onTapGesture {
                                self.shift = thisShift
                                dismiss()
                            }
                    }
                } header: {
                    Text("Shifts").hidden()
                }
            }

            if showSpentShifts {
                ForEach(spentShifts) { thisShift in
                    ShiftRowForAllocSheet(shift: thisShift)
                }
            }
        }
        .listStyle(.insetGrouped)
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
        List {
            Section {
                Toggle("Show spent items", isOn: $showSpentSaved)
            } header: {
                Text("Spent Items").hidden()
            }

            Section("Choose one") {
                if savedsToShow.isEmpty {
                    Text("No saved items with available money")

                } else {
                    ForEach(savedsToShow) { thisSaved in
                        SavedItemRow(saved: thisSaved, user: user)
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
        .listStyle(.insetGrouped)

        .putInTemplate()
        .navigationTitle("Saved Items")
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
            IconManager.savedIcon
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
                Text(saved.totalAvailable.money())
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
                .frame(width: 40, height: 40)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.start.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("Spent: \(shift.totalAllocated.money())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("\(shift.totalAvailable.money())")
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
        AssignAllocationToPayoffView(payoffItem: User.main.getExpenses().last!)
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .tint(Color.red)
            .environment(\.managedObjectContext, PersistenceController.context)

        ChooseShiftForAllocSheet(shift: .constant(User.main.getShifts()[4]))
            .putInNavView(.inline)

        ShiftRowForAllocSheet(shift: User.main.getShifts().randomElement()!)

        SavedItemForAllocSheet(saved: User.main.getSaved().randomElement()!, isAvailable: true)
    }
}
