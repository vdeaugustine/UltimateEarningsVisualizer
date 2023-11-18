//
//  NewHomeViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/3/23.
//

import Combine
import SwiftUI

class NewHomeViewModel: ObservableObject {
    static var shared: NewHomeViewModel = .init()

    init() {
        WageViewModel.shared.wageChangesPublisher
            .sink { [weak self] newWage in
                self?.wage = newWage
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    @ObservedObject var user = User.main
    @ObservedObject var wage = User.main.getWage()
    @ObservedObject var navManager = NavManager.shared

    @Published var selectedTotalItem: TotalTypes = .earned

    @Published var taxesToggleOn: Bool = User.main.getWage().includeTaxes

    @Published var quickMenuOpen: Bool = false

    private var cancellables = Set<AnyCancellable>()

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
                    Image(systemName: IconManager.shiftsString)
                case .taxes:
                    Image(systemName: IconManager.taxesString)
                case .expenses:
                    Image(systemName: IconManager.expenseString)
                case .goals:
                    Image(systemName: IconManager.goalsString)
                case .saved:
                    IconManager.savedIcon
                        .stroke(lineWidth: 1.5)
                        .frame(width: 30, height: 30)

                case .paidOff:
                    Image(systemName: IconManager.paidOffString)
            }
        }

        func amount(_ user: User) -> String {
            switch self {
                case .earned:
                    return user.totalEarned().money()
                case .taxes:
                    return (user.totalEarned() * user.getWage().totalTaxMultiplier).money()
                case .expenses:
                    return user.getAmountForAllExpensesBetween().money()
                case .goals:
                    return user.getAmountForAllGoalsBetween().money()
                case .saved:
                    return user.getAmountSavedBetween().money()
                case .paidOff:
                    return user.amountAllocated().money()
            }
        }

        func quantityLabel(_ vm: NewHomeViewModel) -> String {
            switch vm.selectedTotalItem {
                case .earned:
                    return "\(vm.user.getShifts().count) shifts"
                case .taxes:
                    return"\((vm.user.getWage().totalTaxMultiplier * 100).simpleStr()) %"
                case .expenses:
                    return"\(vm.user.getExpenses().count) items"
                case .goals:
                    return "\(vm.user.getGoals().count) items"
                case .saved:
                    return "\(vm.user.getSaved().count) items"
                case .paidOff:
                    return "\(vm.user.getAllocations().count) allocations"
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
         .init(title: "Time worked", valueString: user.totalTimeWorked().breakDownTime())]
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
         .init(title: "Federal Paid", valueString: user.getFederalTaxesPaid().money())]
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
        [.init(title: "Money", valueString: user.getAmountSavedBetween().money()),
         .init(title: "Time", valueString: user.getTimeSavedBetween().breakDownTime())]
    }

    func getSummaryRows() -> [SummaryRow] {
        switch selectedTotalItem {
            case .earned:
                return earnedSummaryRows
            case .taxes:
                return taxesSummaryRows
            case .expenses:
                return expensesSummaryRows
            case .goals:
                return goalsSummaryRows
            case .saved:
                return savedSummaryRows
            case .paidOff:
                return paidOffSummaryRows
        }
    }

    func getSummaryTotal() -> Double {
        switch selectedTotalItem {
            case .earned:
                return user.totalEarned()
            case .taxes:
                return user.getTotalTaxesPaid()
            case .expenses:
                return user.getAmountForAllExpensesBetween()
            case .goals:
                return user.getAmountForAllGoalsBetween()
            case .saved:
                return user.getAmountSavedBetween()
            case .paidOff:
                return user.getAmountActuallySpentOnGoals() + user.getAmountActuallySpentOnExpenses()
        }
    }
}
