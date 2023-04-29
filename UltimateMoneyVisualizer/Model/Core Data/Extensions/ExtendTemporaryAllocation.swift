//
//  ExtendTemporaryAllocation.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import Foundation
import CoreData

public extension TemporaryAllocation {
    
    convenience init(todayShift: TodayShift, initialAmount: Double, expense: Expense? = nil, goal: Goal? = nil, context: NSManagedObjectContext = PersistenceController.context) {
        self.init(context: context)
        self.id = UUID()
        self.startedTracking = .now
        self.amount = initialAmount
        self.expense = expense
        self.goal = goal
    }
    
    
}
