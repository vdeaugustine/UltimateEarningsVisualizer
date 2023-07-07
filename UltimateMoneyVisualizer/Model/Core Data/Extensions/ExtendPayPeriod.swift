//
//  ExtendPayPeriod.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import CoreData
import Foundation
import Vin

public extension PayPeriod {
    @discardableResult
    convenience init(firstDate: Date,
                     payDay: Date,
                     settings: PayPeriodSettings,
                     user: User,
                     context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.dateSet = Date()
        self.cycleCadence = settings.cycleCadence
        self.user = user
        try context.save()
    }
}

public extension PayPeriod {
    func getCadence() -> PayCycle {
        guard let cycleCadence,
              let cycle = PayCycle(rawValue: cycleCadence)
        else {
            return .biWeekly
        }
        return cycle
    }

    func setCadence(new cycle: PayCycle) throws {
        cycleCadence = cycle.rawValue
        try user?.getContext().save()
    }
}
