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
}