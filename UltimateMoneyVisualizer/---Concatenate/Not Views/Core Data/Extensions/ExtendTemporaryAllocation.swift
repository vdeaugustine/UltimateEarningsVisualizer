//
//  ExtendTemporaryAllocation.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import CoreData
import Foundation

public extension TemporaryAllocation {
    @discardableResult convenience init(initialAmount: Double,
                                        expense: Expense? = nil,
                                        goal: Goal? = nil,
                                        context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)
        self.id = UUID()
        self.startedTracking = .now
        self.amount = initialAmount
        self.expense = expense
        self.goal = goal
        try context.save()
    }

    func add(amount: Double, context: NSManagedObjectContext) throws {
        self.amount += amount
        lastEdited = .now
        try context.save()
    }

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
