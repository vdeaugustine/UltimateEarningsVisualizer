//
//  GoalContributionsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/19/23.
//

import SwiftUI

struct GoalContributionsView: View {
    @Environment (\.dismiss) private var dismiss
    let payoffItem: PayoffItem

    var body: some View {
        List {
            if !payoffItem.getShifts().isEmpty {
                Section("Shifts") {
                    ForEach(payoffItem.getAllocations()) { alloc in
                        if let shift = alloc.shift {
                            AllocShiftRow(shift: shift, allocation: alloc)
                        }
                    }
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
    }
}

#Preview {
    GoalContributionsView(payoffItem: User.main.getGoals().randomElement()!)
//        .templateForPreview()
}
