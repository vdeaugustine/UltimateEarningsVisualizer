//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import Foundation
import CoreData


public extension Allocation {
    
    convenience init(
        amount: Double,
        expense: Expense? = nil,
        goal: Goal? = nil,
        shift: Shift? = nil,
        saved: Saved? = nil,
        date: Date = .now,
        context: NSManagedObjectContext = PersistenceController.context
    ) {
        self.init(context: context)
        self.id = UUID()
        self.date = date
        self.amount = amount
        self.expense = expense
        self.goal = goal
        self.shift = shift
        self.savedItem = saved
        
        try? context.save()
    }
    
    
}

extension Allocation {
    
    
    
    
    
}
