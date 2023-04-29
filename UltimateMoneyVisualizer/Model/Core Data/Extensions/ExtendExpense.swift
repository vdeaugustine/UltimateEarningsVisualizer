//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import Vin

// MARK: - Initializer

public extension Expense {
    convenience init(title: String, info: String?, amount: Double, dueDate: Date?, context: NSManagedObjectContext = PersistenceController.context) {
        self.init(context: context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.id = UUID()
    }
}

public extension Expense {
    static let testItemExpense: Expense = {
        let expense1 = Expense(title: "Groceries", info: "This expense is for groceries", amount: 50.00, dueDate: .now.addDays(27), context: PersistenceController.testing)
        expense1.dateCreated = .now.addDays(-48)
        return expense1
    }()
    
    var temporarilyPaidOff: Double {
        guard let temporaryAllocations = temporaryAllocations as? Set<TemporaryAllocation> else {
            return 0
        }
        
        return temporaryAllocations.reduce(Double(0), {$0 + $1.amount})
    }

    var titleStr: String { title ?? "Unknown Expense" }

    var amountMoneyStr: String {
        return amount.formattedForMoney(includeCents: true)
    }

    var amountPaidOff: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalTime: TimeInterval {
        guard let dateCreated, let dueDate else { return 0 }
        return dueDate - dateCreated
    }

    var timeRemaining: TimeInterval {
        guard let dueDate else { return 0 }
        return dueDate - .now
    }

    var amountRemainingToPayOff: Double { return amount - amountPaidOff }

    static func createExampleExpenses(user: User, context: NSManagedObjectContext) throws {
        func randomDateWithin(days: Int) -> Date {
            let calendar = Calendar.current
            let today = Date()
            let earliestDate = calendar.date(byAdding: .day, value: days, to: today)

            guard let earliest = earliestDate, earliest <= today else {
                return .now
            }

            let latest = calendar.startOfDay(for: today)
            let randomTimeInterval = TimeInterval.random(in: earliest.timeIntervalSince1970 ..< latest.timeIntervalSince1970)
            let randomDate = Date(timeIntervalSince1970: randomTimeInterval)

            return randomDate
        }

        let goBackDays = 90
        let expense1 = Expense(context: context)
        expense1.title = "Groceries"
        expense1.amount = 50.00
        expense1.dateCreated = randomDateWithin(days: -goBackDays)
        expense1.dueDate = randomDateWithin(days: goBackDays)
        expense1.user = user
        expense1.info = "This expense is for groceries"

        let expense2 = Expense(context: context)
        expense2.title = "Gas"
        expense2.amount = 30.00
        expense2.dateCreated = Date()
        expense2.dateCreated = randomDateWithin(days: -goBackDays)
        expense2.dueDate = randomDateWithin(days: goBackDays)
        expense2.user = user
        expense2.info = "This expense is for gas"

        let expense3 = Expense(context: context)
        expense3.title = "Electricity"
        expense3.amount = 100.00
        expense3.dateCreated = Date()
        expense3.dateCreated = randomDateWithin(days: -goBackDays)
        expense3.dueDate = randomDateWithin(days: goBackDays)
        expense3.user = user
        expense3.info = "This expense is for electricity"

        let expense4 = Expense(context: context)
        expense4.title = "Internet"
        expense4.amount = 60.00
        expense4.dateCreated = Date()
        expense4.dateCreated = randomDateWithin(days: -goBackDays)
        expense4.dueDate = randomDateWithin(days: goBackDays)
        expense4.user = user
        expense4.info = "This expense is for internet"

        let expense5 = Expense(context: context)
        expense5.title = "Entertainment"
        expense5.amount = 25.00
        expense5.dateCreated = randomDateWithin(days: -goBackDays)
        expense5.dueDate = randomDateWithin(days: goBackDays)
        expense5.user = user
        expense5.info = "This expense is for entertainment"

        try context.save()
    }
}
