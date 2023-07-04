//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

public extension Wage {
    @discardableResult convenience init(amount: Double,
                                        isSalary: Bool,
                                        user: User,
                                        includeTaxes: Bool,
                                        stateTax: Double?,
                                        federalTax: Double?,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.amount = amount
        self.isSalary = isSalary
        self.user = user
        self.includeTaxes = includeTaxes
        if let stateTax {
            self.stateTaxPercentage = stateTax
        }
        if let federalTax {
            self.federalTaxPercentage = federalTax
        }
        
        try context.save()
    }
    
    var stateTaxMultiplier: Double {
        stateTaxPercentage / 100
    }
    
    var federalTaxMultiplier: Double {
        federalTaxPercentage / 100
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
