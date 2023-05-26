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
        perMinute / 60
    }

    var perMinute: Double {
        amount / 60
    }

    var perDay: Double {
        amount * hoursPerDay
    }

    var perWeek: Double {
        perDay * daysPerWeek
    }

    var perMonth: Double {
        perWeek * 4
    }

    var perYear: Double {
        perWeek * weeksPerYear
    }
    
    
}
