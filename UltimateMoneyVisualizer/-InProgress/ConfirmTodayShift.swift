//
//  ConfirmTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/14/23.
//

import SwiftUI
import Vin

// MARK: - ConfirmTodayShift

struct ConfirmTodayShift: View {
    @ObservedObject private var user: User = .main
    @State private var temporaryItems: [TempTodayPayoff] = []
    @State private var showConfirmation = false

    private var willEarn: Double {
        user.getWage().perSecond * shiftDuration
    }

    let haveEarned: Double
    let shiftDuration: TimeInterval
    let initialPayoffs = User.main.getQueue().map { TempTodayPayoff(payoff: $0) }

    private var tempPayoffs: [TempTodayPayoff] {
        payOffExpenses(with: haveEarned, expenses: initialPayoffs).reversed()
    }

    private var filteredTempPayoffs: [TempTodayPayoff] {
        tempPayoffs.filter { $0.progressAmount > 0.01 }
    }

    var body: some View {
        List {
            ForEach(temporaryItems) { item in

                if item.progressAmount > 0.01 {
                    Text(item.title)
                        .spacedOut {
                            Text(item.progressAmount.formattedForMoney())
                                .fontWeight(.bold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                }
            }
            .onDelete { indexSet in
                temporaryItems.remove(atOffsets: indexSet)
            }
        }
        .putInTemplate()
        .navigationTitle("Confirm Today Shift")
        .onAppear {
            let temps = payOffExpenses(with: haveEarned, expenses: initialPayoffs).reversed()
            let filteredTemps = temps.filter { $0.progressAmount > 0.01 }
            temporaryItems = filteredTemps
        }
        .bottomCapsule(label: "Confirm") {
            showConfirmation.toggle()
        }
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }
        .confirmationDialog("Save this shift and all allocations?", isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Save", role: .destructive) {
                temporaryItems.forEach { _ in
                }
            }
        }
    }
}

// MARK: - ConfirmTodayShift_Previews

struct ConfirmTodayShift_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTodayShift(haveEarned: (Date.fivePM - Date.nineAM) * User.main.getWage().perSecond, shiftDuration: Date.fivePM - Date.nineAM)
            .putInNavView(.inline)
    }
}
