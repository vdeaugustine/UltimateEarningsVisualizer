//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import Vin

public extension Goal {
    @discardableResult convenience init(title: String, info: String?, amount: Double, dueDate: Date?, context: NSManagedObjectContext = PersistenceController.context) {
        self.init(context: context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.id = UUID()
    }
    
    
}

public extension Goal {
    static func makeExampleGoals(user: User, context: NSManagedObjectContext) throws {

        let goal1 = Goal(title: "New car fund", info: "Saving up for a down payment on a new car", amount: 10000, dueDate: Date().addingTimeInterval(31536000), context: context)
        let goal2 = Goal(title: "Vacation to Hawaii", info: "Planning a trip to Hawaii with my family", amount: 5000, dueDate: Date().addingTimeInterval(157680000), context: context)
        let goal3 = Goal(title: "Emergency fund", info: "Saving up for unexpected expenses", amount: 2000, dueDate: nil, context: context)
        let goal4 = Goal(title: "Home renovations", info: "Renovating my kitchen and bathroom", amount: 15000, dueDate: Date().addingTimeInterval(63072000), context: context)
        let goal5 = Goal(title: "College fund for kids", info: "Saving up for my kids' college education", amount: 50000, dueDate: Date().addingTimeInterval(630720000), context: context)
        let goal6 = Goal(title: "Retirement fund", info: "Planning for retirement", amount: 100000, dueDate: nil, context: context)
        let goal7 = Goal(title: "Business venture", info: "Investing in a new business opportunity", amount: 25000, dueDate: Date().addingTimeInterval(157680000), context: context)


    }
}

public extension Goal {
    static let disneyWorld: Goal = {
        let goal = Goal(context: PersistenceController.context)
        goal.amount = 2_329
        goal.dateCreated = .now
        goal.dueDate = .now.addDays(278)
        goal.title = "Disney World"
        goal.info = "with Noah boy"
        let user = User(context: PersistenceController.context)
        user.username = "some user name"
        user.email = "vinnie@vinnie.vin"
        goal.user = user
        return goal
    }()
    
    var temporarilyPaidOff: Double {
        guard let temporaryAllocations = temporaryAllocations as? Set<TemporaryAllocation>
        else {
            return 0
        }

        let totalTemporaryAllocated = temporaryAllocations.reduce(Double(0)) { $0 + $1.amount }

        return totalTemporaryAllocated + amountPaidOff
    }

    var temporaryRemainingToPayOff: Double {
        amount - temporarilyPaidOff
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
}
