//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

public extension Wage {
    @discardableResult convenience init(amount: Double, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.amount = amount
        self.user = user
        try context.save()
    }

    var hourly: Double {
        amount
    }

    var secondly: Double {
        amount / 60 / 60
    }

    var perSecond: Double {
        amount / 3_600
    }

    var perMinute: Double {
        amount / 60
    }

    var perDay: Double {
        amount * 8
    }

    var perWeek: Double {
        perDay * 5
    }

    var perMonth: Double {
        perWeek * 4
    }

    var perYear: Double {
        perMonth * 12
    }
}
