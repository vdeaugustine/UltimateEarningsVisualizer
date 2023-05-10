//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import Vin


public extension Saved {
    
    @discardableResult convenience init(amount: Double, title: String, info: String? = nil, date: Date, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.amount = amount
        self.title = title
        self.info = info
        self.date = date
        self.user = user
        try context.save()
    }
}



public extension Saved {
    
    
    func getDate() -> Date {
        self.date ?? .now.addDays(-10)
    }
    
    func getTitle() -> String {
        self.title ?? "Unknown Title"
    }
    
    func getAmount() -> Double {
        self.amount
    }
    
    func goalsAllocatedTo() -> [Goal] {
        let allocations = getAllocations()

        let goals = allocations.compactMap { $0.goal }
        let asSet = Set(goals)

        return Array(asSet)
    }

    func expensesAllocatedTo() -> [Expense] {
        let allocations = getAllocations()

        let expenses = allocations.compactMap { $0.expense }
        let asSet = Set(expenses)

        return Array(asSet)
    }
    
    func getPayoffItemsAllocatedTo() -> [PayoffItem] {
        let expenses = expensesAllocatedTo()
        let goals = goalsAllocatedTo()
        let combined: [PayoffItem] = goals + expenses

        return combined.sorted(by: { self.amountAllocated(for: $0) > self.amountAllocated(for: $1) })
    }
    
    func amountAllocated(for payoffItem: PayoffItem) -> Double {
        var sum: Double = 0

        for alloc in getAllocations() {
            var id: UUID?
            if let goal = alloc.goal {
                id = goal.id
            } else if let expense = alloc.expense {
                id = expense.id
            }

            if let id,
               id == payoffItem.getID() {
                sum += alloc.amount
            }
        }

        return sum
    }
    
    var totalAllocated: Double {
        let allocations = getAllocations()
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalAvailable: Double {
        amount - totalAllocated
    }
    
    func getAllocations() -> [Allocation] {
        guard let allocations = allocations?.allObjects as? [Allocation] else {
            return []
        }

        return allocations
    }
    
    
    static func makeExampleSavedItems(user: User, context: NSManagedObjectContext) throws {
        
        // Create a date formatter to format the date attribute of each saved item.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create some dummy saved items with interesting titles and descriptions.
        let savedItem1 = Saved(context: context)
        savedItem1.title = "Lunch at Home"
        savedItem1.amount = 5.0
        savedItem1.date = .now.addDays(Double.random(in: -3 ... 0))
        savedItem1.info = "Didn't go out for lunch today, ate at home instead."
        savedItem1.user = user
        
        let savedItem2 = Saved(context: context)
        savedItem2.title = "Movie Night"
        savedItem2.amount = 12.5
        savedItem2.date = .now.addDays(Double.random(in: -3 ... 0))
        savedItem2.info = "Watched a movie at home with friends instead of going to the theater."
        savedItem2.user = user
        
        let savedItem3 = Saved(context: context)
        savedItem3.title = "Cancelled Gym Membership"
        savedItem3.amount = 30.0
        savedItem3.date = .now.addDays(Double.random(in: -3 ... 0))
        savedItem3.info = "Decided to cancel gym membership and do workouts at home."
        savedItem3.user = user
        
        // Save the context.
        try context.save()
    }

}
