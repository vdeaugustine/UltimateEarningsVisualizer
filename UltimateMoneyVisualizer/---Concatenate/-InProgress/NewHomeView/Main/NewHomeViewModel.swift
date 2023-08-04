//
//  NewHomeViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/3/23.
//

import SwiftUI

class NewHomeViewModel: ObservableObject {
    static var shared: NewHomeViewModel = .init()

    @ObservedObject var user = User.main
    @ObservedObject var wage = User.main.getWage()
    @ObservedObject var navManager = NavManager.shared

    @Published var selectedTotalItem: TotalTypes = .earned
    
    @Published var taxesToggleOn: Bool = User.main.getWage().includeTaxes

    enum TotalTypes: String, CaseIterable, Identifiable, Hashable, CustomStringConvertible {
        case earned, taxes, expenses, goals, saved
        case paidOff = "Paid Off"
        

        var title: String { rawValue.capitalized }

        var description: String { rawValue.capitalized }

        var id: Self { self }

        @ViewBuilder var icon: some View {
            switch self {
                case .earned:
                    Image(systemName: "chart.line.uptrend.xyaxis")
                case .taxes:
                    Image(systemName: "percent")
                case .expenses:
                    Image(systemName: "cart")
                case .goals:
                    Image(systemName: "scope")
                case .saved:
                    PiggyBankShape()
                        .stroke(lineWidth: 1.5)
                        .frame(width: 30, height: 30)
                    
                case .paidOff:
                    Image(systemName: "checklist")
            }
        }

        func amount(_ vm: NewHomeViewModel) -> String {
            switch self {
                case .earned:
                    vm.user.totalEarned().money()
                case .taxes:
                    (vm.user.totalEarned() * vm.user.getWage().totalTaxMultiplier).money()
                case .expenses:
                    vm.user.getExpensesSpentBetween().money()
                case .goals:
                    vm.user.getGoalsSpentBetween().money()
                case .saved:
                    vm.user.getAmountSavedBetween().money()
                case .paidOff:
                    vm.user.amountAllocated().money()
            }
        }

        func quantityLabel(_ vm: NewHomeViewModel) -> String {
            switch vm.selectedTotalItem {
                case .earned:
                    "\(vm.user.getShifts().count) shifts"
                case .taxes:
                    "\((vm.user.getWage().totalTaxMultiplier * 100).simpleStr()) %"
                case .expenses:
                    "\(vm.user.getExpenses().count) items"
                case .goals:
                    "\(vm.user.getGoals().count) items"
                case .saved:
                    "\(vm.user.getSaved().count) items"
                case .paidOff:
                    "\(vm.user.getAllocations().count) items"
            }
        }
    }
}
