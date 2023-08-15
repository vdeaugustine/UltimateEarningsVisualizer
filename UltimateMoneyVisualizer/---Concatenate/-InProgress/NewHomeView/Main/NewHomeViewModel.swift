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

    func payoffItemTapped(_ item: PayoffItem?) {
        if let goal = item as? Goal {
            navManager.appendCorrectPath(newValue: .goal(goal))
        } else if let expense = item as? Expense {
            navManager.appendCorrectPath(newValue: .expense(expense))
        }
    }

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

        func amount(_ user: User) -> String {
            switch self {
                case .earned:
                    user.totalEarned().money()
                case .taxes:
                    (user.totalEarned() * user.getWage().totalTaxMultiplier).money()
                case .expenses:
                    user.getAmountForAllExpensesBetween().money()
                case .goals:
                    user.getAmountForAllGoalsBetween().money()
                case .saved:
                    user.getAmountSavedBetween().money()
                case .paidOff:
                    user.amountAllocated().money()
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
                    "\(vm.user.getAllocations().count) allocations"
            }
        }
    }

    struct SummaryRow: Identifiable, Hashable {
        var id: Self { self }
        
        
        let title: String
        let valueString: String
        
    }

    var earnedSummaryRows: [SummaryRow] {
        [.init(title: "Shifts", valueString: user.getShifts().count.str),
         .init(title: "Time worked", valueString: user.totalTimeWorked().breakDownTime()),
         ]
    }

    var paidOffSummaryRows: [SummaryRow] {
        [.init(title: "Expenses", valueString: user.getAmountForAllExpensesBetween().money()),
         .init(title: "Goals", valueString: user.getAmountForAllGoalsBetween().money()),
         .init(title: "Unspent", valueString: user.totalNetMoneyBetween().money())]
    }

    var taxesSummaryRows: [SummaryRow] {
        [.init(title: "State", valueString: "\((user.getWage().stateTaxMultiplier * 100).simpleStr()) %"),
         .init(title: "State Paid", valueString: user.getStateTaxesPaid().money()),
         .init(title: "Federal", valueString: "\((user.getWage().federalTaxMultiplier * 100).simpleStr()) %"),
         .init(title: "Federal Paid", valueString: user.getFederalTaxesPaid().money())
        ]
    }

    var expensesSummaryRows: [SummaryRow] {
        [.init(title: "Paid off", valueString: user.getAmountActuallySpentOnExpenses().money()),
         .init(title: "Remaining to pay", valueString: user.getAmountRemainingToPay_Expenses().money())]
    }
    
    var goalsSummaryRows: [SummaryRow] {
        [.init(title: "Paid off", valueString: user.getAmountActuallySpentOnGoals().money()),
         .init(title: "Remaining to pay", valueString: user.getAmountRemainingToPay_Goals().money())]
    }
    
    var savedSummaryRows: [SummaryRow] {
        [
            .init(title: "Money", valueString: user.getAmountSavedBetween().money()),
            .init(title: "Time", valueString: user.getTimeSavedBetween().breakDownTime())
        ]
    }
    
    func getSummaryRows() -> [SummaryRow] {
        switch selectedTotalItem {
            case .earned:
                earnedSummaryRows
            case .taxes:
                taxesSummaryRows
            case .expenses:
                expensesSummaryRows
            case .goals:
                goalsSummaryRows
            case .saved:
                savedSummaryRows
            case .paidOff:
                paidOffSummaryRows
        }
    }
    
    func getSummaryTotal() -> Double {
        switch selectedTotalItem {
            case .earned:
                user.totalEarned()
            case .taxes:
                user.getTotalTaxesPaid()
            case .expenses:
                user.getAmountForAllExpensesBetween()
            case .goals:
                user.getAmountForAllGoalsBetween()
            case .saved:
                user.getAmountSavedBetween()
            case .paidOff:
                user.getAmountActuallySpentOnGoals() + user.getAmountActuallySpentOnExpenses()
        }
    }
}
