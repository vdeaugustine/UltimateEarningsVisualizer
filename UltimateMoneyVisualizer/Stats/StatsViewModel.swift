import Foundation
import SwiftUI

// MARK: - StatsViewModel

class StatsViewModel: ObservableObject {
    static var shared = StatsViewModel()
    @ObservedObject var user: User = User.main
    @Published var selectedSection: MoneySection = .earned
    @Published var firstDate: Date = .now.addDays(-5)
    @Published var secondDate: Date = .endOfDay()
    @ObservedObject var navManager = NavManager.shared
    @Published var earnedItems: [Shift] = []
    @Published var savedItems: [Saved] = []
    @Published var expenseItems: [Expense] = []
    @Published var goalItems: [Goal] = []

    typealias HashableAndIdentifiable = Hashable & Identifiable
    
    

    func chartFooter(for type: MoneySection) -> String {
        let interjection: String
        switch type {
            case .earned:
                interjection = "earned by working"
            case .goals, .spent:
                interjection = "spent"
            case .saved:
                interjection = "saved"
        }

        return "Shows the total amount of money you had \(interjection) up to each day, including all previous days not shown"
    }

    var listHeader: String {
        switch selectedSection {
            case .earned:
                return "Shifts"
            case .spent:
                return "Expenses"
            case .saved:
                return "Saved"
            case .goals:
                return "Goals"
        }
    }

    func rowText(forIndex index: Int) -> (title: String, detail: String) {
        let item = itemsForList.safeGet(at: index)
        if let shift = item as? Shift {
            return (shift.start.getFormattedDate(format: .abbreviatedMonth), shift.totalEarned.money())
        } else if let saved = item as? Saved {
            return (saved.getTitle(), saved.getAmount().money())
        } else if let goal = item as? Goal {
            return (goal.titleStr, goal.amountMoneyStr)
        } else if let expense = item as? Expense {
            return (expense.titleStr, expense.amountMoneyStr)
        }
        return ("", "")
    }

    func rowIcon(forIndex index: Int) -> (imageName: String, color: Color) {
        let item = itemsForList.safeGet(at: index)
        if item is Shift {
            return (IconManager.shiftsString, .black)
        } else if item is Saved {
            return ("chart.line.uptrend.xyaxis", .black)
        } else if item is Goal {
            return (IconManager.goalsString, .black)
        } else if item is Expense {
            return (IconManager.expenseString, .black)
        }
        return ("", .clear)
    }

    func tapAction(index: Int) {
        guard let item = itemsForList.safeGet(at: index)

        else { return }
//        navManager.homeNavPath.append(item)

        if let shift = item as? Shift {
//            navManager.homeNavPath.appendView(.)
            navManager.appendCorrectPath(newValue: .shift(shift))
        } else if let saved = item as? Saved {
//            SavedDetailView(saved: saved)
//            navManager.homeNavPath.appendView(.)
            navManager.appendCorrectPath(newValue: .saved(saved))
        } else if let goal = item as? Goal {
//            GoalDetailView(goal: goal)
            navManager.appendCorrectPath(newValue: .goal(goal))
        } else if let expense = item as? Expense {
            navManager.appendCorrectPath(newValue: .expense(expense))
        }
    }

    var itemsForList: [any HashableAndIdentifiable] {
        switch selectedSection {
            case .earned:
                return earnedItems
//                return user.getShiftsBetween(startDate: firstDate, endDate: secondDate)
            case .spent:
                return expenseItems
//                return user.getExpensesBetween(startDate: firstDate, endDate: secondDate)
            case .saved:
                return savedItems
//                return user.getSavedBetween(startDate: firstDate, endDate: secondDate)

            case .goals:
                return goalItems
//                return user.getGoalsBetween(startDate: firstDate, endDate: secondDate)
        }
    }
    
    func refresh() {
        earnedItems = user.getShiftsBetween(startDate: firstDate, endDate: secondDate)
        expenseItems = user.getExpensesBetween(startDate: firstDate, endDate: secondDate)
        savedItems = user.getSavedBetween(startDate: firstDate, endDate: secondDate)
        goalItems = user.getGoalsBetween(startDate: firstDate, endDate: secondDate)
    }

//
//    @ViewBuilder func destinationIfTapped<V: Identifiable>(_ item: V) -> some View {
//        if let shift = item as? Shift {
//            ShiftDetailView(shift: shift)
//        } else if let saved = item as? Saved {
//            SavedDetailView(saved: saved)
//        } else if let goal = item as? Goal {
//            PayoffItemDetailView(payoffItem: goal)
//        } else if let expense = item as? Expense {
//            ExpenseDetailView(expense: expense)
//        }
//    }

    var dataItems: [HorizontalDataDisplay.DataItem] {
        var retArr = [HorizontalDataDisplay.DataItem]()

        switch selectedSection {
            // TODO: Figure out if you want to have an ALL section
//            case .all:
//                retArr = [.init(label: "Items", value: user.getShiftsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
//                          .init(label: "Amount", value: user.totalNetMoneyBetween(firstDate, secondDate).money(), view: nil),
//                          .init(label: "Time", value: user.convertMoneyToTime(money: user.totalNetMoneyBetween(firstDate, secondDate)).formatForTime(), view: nil)]
            case .earned:
                retArr = [.init(label: "Shifts", value: user.getShiftsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getTotalEarnedBetween(startDate: firstDate, endDate: secondDate).money(), view: nil),
                          .init(label: "Time", value: user.getTimeWorkedBetween(startDate: firstDate, endDate: secondDate).breakDownTime(), view: nil)]
            case .spent:
                retArr = [.init(label: "Expenses", value: user.getExpensesBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getAmountForAllExpensesBetween(startDate: firstDate, endDate: secondDate).money(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getAmountForAllExpensesBetween(startDate: firstDate, endDate: secondDate)).breakDownTime(), view: nil)]
            case .saved:
                retArr = [.init(label: "Saved", value: user.getSavedBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getAmountSavedBetween(startDate: firstDate, endDate: secondDate).money(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getAmountSavedBetween(startDate: firstDate, endDate: secondDate)).breakDownTime(), view: nil)]
            case .goals:
                retArr = [.init(label: "Goals", value: user.getGoalsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                          .init(label: "Amount", value: user.getAmountForAllGoalsBetween(startDate: firstDate, endDate: secondDate).money(), view: nil),
                          .init(label: "Time", value: user.convertMoneyToTime(money: user.getAmountForAllGoalsBetween(startDate: firstDate, endDate: secondDate)).breakDownTime(), view: nil)]
        }

        return retArr
    }
}

extension StatsViewModel {
    enum MoneySection: String, CaseIterable, Identifiable, Hashable {
        case earned, spent, saved, goals
        var id: MoneySection { self }
    }
}
