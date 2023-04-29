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
    convenience init(title: String, info: String?, amount: Double, dueDate: Date?) {
        self.init(context: PersistenceController.context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.id = UUID()
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
