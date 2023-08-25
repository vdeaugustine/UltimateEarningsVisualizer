
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
    @ObservedObject var vm: PayoffItemDetailViewModel

    var body: some View {
        List {
            if !payoffItem.getShifts().isEmpty {
                Section("Shifts") {
                    ForEach(vm.allocations) { alloc in
                        if let shift = alloc.shift {
                            NavigationLink {
                                ShiftDetailView(shift: shift)
                            } label: {
                                AllocShiftRow(shift: shift, allocation: alloc)
                            }
                                
                        }
                    }
                    .onDelete(perform: deleteShift)
                }
            }

            if !payoffItem.getSavedItems().isEmpty {
                Section("Saved Items") {
                    ForEach(vm.allocations) { alloc in
                        if let saved = alloc.savedItem {
                            AllocSavedRow(saved: saved, allocation: alloc)
                        }
                    }
                }
            }
        }
        .navigationTitle("Contributions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AssignAllocationToPayoffView(payoffItem: payoffItem)
                } label: {
                    Label("New", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
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
                    vm.allocations = payoffItem.getAllocations()
                    vm.amountPaidOff = payoffItem.amountPaidOff
                } catch {
                    showingErrorAlert = true
                }
            }
        }
    }
}

// MARK: - GoalContributionsView_Previews

struct GoalContributionsView_Previews: PreviewProvider {
    
    static let item = User.main.getGoals().randomElement()!
    
    static var previews: some View {
        PayoffContributionsView(payoffItem: item, vm: .init(payoffItem: item))
    }
}

