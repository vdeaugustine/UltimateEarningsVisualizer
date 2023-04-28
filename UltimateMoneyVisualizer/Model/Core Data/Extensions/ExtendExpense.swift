//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import Foundation
import CoreData

extension Expense {
    
    
    static func createExampleExpenses(user: User, context: NSManagedObjectContext) throws {
        
        let expense1 = Expense(context: context)
        expense1.title = "Groceries"
        expense1.amount = 50.00
        expense1.dateCreated = Date()
        expense1.user = user
        
        let expense2 = Expense(context: context)
        expense2.title = "Gas"
        expense2.amount = 30.00
        expense2.dateCreated = Date()
        expense2.user = user
        
        let expense3 = Expense(context: context)
        expense3.title = "Electricity"
        expense3.amount = 100.00
        expense3.dateCreated = Date()
        expense3.user = user
        
        let expense4 = Expense(context: context)
        expense4.title = "Internet"
        expense4.amount = 60.00
        expense4.dateCreated = Date()
        expense4.user = user
        
        let expense5 = Expense(context: context)
        expense5.title = "Entertainment"
        expense5.amount = 25.00
        expense5.dateCreated = Date()
        expense5.user = user
        
        try context.save()
    }

    
}
