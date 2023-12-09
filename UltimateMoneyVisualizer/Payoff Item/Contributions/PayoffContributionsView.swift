
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
    @State private var showingErrorAlert = false
    @ObservedObject var vm: PayoffItemDetailViewModel

    var body: some View {
        List {
            if !vm.payoffItem.getShifts().isEmpty {
                Section("Shifts") {
                    ForEach(vm.allocations) { alloc in
                        if let shift = alloc.shift {
                            Button {
                                NavManager.shared.appendCorrectPath(newValue: .shift(shift))
                            } label: {
                                AllocShiftRow(shift: shift, allocation: alloc)
                            }
                            .foregroundStyle(Color.black)
                        }
                    }
                    .onDelete(perform: deleteShift)
                }
            }
            

            if !vm.payoffItem.getSavedItems().isEmpty {
                Section("Saved Items") {
                    ForEach(vm.allocations) { alloc in
                        if let saved = alloc.savedItem {
                            AllocSavedRow(saved: saved, allocation: alloc)
                                .onTapGesture {
                                    NavManager.shared.appendCorrectPath(newValue: .saved(saved))
                                }
                        }
                    }
                }
            }
            
            if vm.payoffItem.getSavedItems().isEmpty,
               vm.payoffItem.getShifts().isEmpty {
                Section  {
                    Text("No contributions for this item yet")
                } header: {
                    Text("None yet header").hidden()
                }
            }
            
        }
        .navigationTitle("Contributions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .assignAllocationToPayoff(vm))
                } label: {
                    Label("New", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
            }

        }

        .accentColor(User.main.getSettings().themeColor)
        .tint(User.main.getSettings().themeColor)
        .putInTemplate()
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text("Error deleting shift"), dismissButton: .default(Text("OK")))
        }
    }

    private func deleteShift(at offsets: IndexSet) {
        offsets.forEach { index in
            if let alloc = vm.payoffItem.getAllocations().safeGet(at: index) {
                do {
                    try vm.payoffItem.removeAllocation(alloc: alloc)
                    vm.allocations = vm.payoffItem.getAllocations()
                    vm.amountPaidOff = vm.payoffItem.amountPaidOff
                } catch {
                    showingErrorAlert = true
                }
            }
        }
    }
}

// MARK: - GoalContributionsView_Previews

struct GoalContributionsView_Previews: PreviewProvider {
    static let item = User.testing.getGoals().randomElement()!

    static var previews: some View {
        PayoffContributionsView(vm: .init(payoffItem: item))
            .templateForPreview()
    }
}
