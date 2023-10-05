//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

public extension Allocation {
    @discardableResult convenience init(amount: Double,
                                        expense: Expense? = nil,
                                        goal: Goal? = nil,
                                        shift: Shift? = nil,
                                        saved: Saved? = nil,
                                        date: Date = .now,
                                        context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)
        self.id = UUID()
        self.date = date
        self.amount = amount
        self.expense = expense
        self.goal = goal
        self.shift = shift
        self.savedItem = saved

        if let goal {
            self.user = goal.user
        } else if let expense {
            self.user = expense.user
        } else if let shift {
            self.user = shift.user
        } else if let saved {
            self.user = saved.user
        } else {
            self.user = User.main
        }

        try context.save()
    }

    @discardableResult convenience init(tempPayoff: TempTodayPayoff,
                                        shift: Shift,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)

        if let goal = user.getGoals().first(where: { $0.getID() == tempPayoff.id }) {
            self.goal = goal
        } else if let expense = user.getExpenses().first(where: { $0.getID() == tempPayoff.id }) {
            self.expense = expense
        }

        self.amount = tempPayoff.progressAmount
        self.date = Date()
        self.shift = shift
        self.id = UUID()
        self.user = user
        try context.save()
    }

//    @discardableResult static func makeExampleAllocs(user: User, context: NSManagedObjectContext) throws -> [Allocation] {
//        // Get all the shifts that are available
//        var shifts: [Shift] { user.getShifts().sorted { $0.totalAvailable > $1.totalAvailable } }
//        // Get all the saved items
    ////        var saved: [Saved] { user.getSaved().sorted {  > $1.totalAvailable } }
//        // Get all the goals
//        var goals: [Goal] { user.getGoals() }
//        // Get all the expenses
//        var expenses: [Expense] { user.getExpenses() }
//    }
}

extension Allocation {
    func getItemTitle() -> String {
        if let goal {
            return goal.titleStr
        }
        if let expense {
            return expense.titleStr
        }
        return ""
    }

    var payoffType: PayoffType {
        if goal != nil {
            return .goal
        }
        return .expense
    }
}

// MARK: - Equatable

extension Allocation {
    static func == (lhs: Allocation, rhs: Allocation) -> Bool {
        let sameTypeAndAmount = lhs.payoffType == rhs.payoffType && lhs.amount == rhs.amount

        let samePayoff = (lhs.expense == rhs.expense) || (lhs.goal == rhs.goal)

        let sameShift = lhs.shift != nil && rhs.shift != nil && lhs.shift == rhs.shift

        let sameSavedItem = lhs.savedItem != nil && rhs.savedItem != nil && lhs.savedItem == rhs.savedItem

        let sameSource = sameShift || sameSavedItem

        return sameTypeAndAmount && samePayoff && sameSource
    }

    func isEqual(to tempPayoff: TempTodayPayoff, todayShiftStart: Date, todayShiftEnd: Date) -> Bool {
        guard let shift else { return false }
        guard tempPayoff.type == payoffType else { return false }

        let sameAmount = tempPayoff.progressAmount == amount
        let sameShiftStart = shift.start == todayShiftStart
        let sameShiftEnd = shift.end == todayShiftEnd

        return sameAmount && sameShiftStart && sameShiftEnd
    }
}
