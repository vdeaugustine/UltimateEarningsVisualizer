
//
//  GoalContributionsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/19/23.
//

import SwiftUI

// MARK: - PayoffContributionsView

struct PayoffContributionsView: View {
    @Environment(\.dismiss) private var dismiss
    let payoffItem: PayoffItem
    @State private var showingErrorAlert = false

    var body: some View {
        List {
            if !payoffItem.getShifts().isEmpty {
                Section("Shifts") {
                    ForEach(payoffItem.getAllocations()) { alloc in
                        if let shift = alloc.shift {
                            AllocShiftRow(shift: shift, allocation: alloc)
                                .onTapGesture {
                                    NavManager.shared.appendCorrectPath(newValue: .shift(shift))
                                }
                        }
                    }
                    .onDelete(perform: deleteShift)
                }
            }

            if !payoffItem.getSavedItems().isEmpty {
                Section("Saved Items") {
                    ForEach(payoffItem.getAllocations()) { alloc in
                        if let saved = alloc.savedItem {
                            AllocSavedRow(saved: saved, allocation: alloc)
                        }
                    }
                }
            }
        }
        .navigationTitle("Contributions")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AssignAllocationToPayoffView(payoffItem: payoffItem)
                } label: {
                    Label("New", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }

        .accentColor(User.main.getSettings().themeColor)
        .tint(User.main.getSettings().themeColor)
        .putInTemplate()
        .putInNavView(.large)
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Error deleting shift"), dismissButton: .default(Text("OK")))
        }
    }

    private func deleteShift(at offsets: IndexSet) {
        offsets.forEach { index in
            if let alloc = payoffItem.getAllocations().safeGet(at: index) {
                do {
                    try payoffItem.removeAllocation(alloc: alloc)
                } catch {
                    showingErrorAlert = true
                }
            }
        }
    }
}

// MARK: - GoalContributionsView_Previews

struct GoalContributionsView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffContributionsView(payoffItem: User.main.getGoals().randomElement()!)
    }
}

