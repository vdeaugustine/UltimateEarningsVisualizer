//
//  ExtendPayPeriodSettings.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/6/23.
//

import CoreData
import Foundation
import Vin

public extension PayPeriodSettings {
    @discardableResult
    convenience init(cycleCadence: PayCycle,
                     user: User,
                     context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.dateSet = Date()
        self.cycleCadence = cycleCadence.rawValue
        self.user = user
        try context.save()
    }
}

public extension PayPeriodSettings {
    /// Gets the `PayCycle` enum case if it exists. Defaults to **biWeekly** if not.
    func getCycleCadence() -> PayCycle {
        guard let cycleCadence else { return PayCycle.biWeekly }
        return PayCycle(rawValue: cycleCadence) ?? .biWeekly
    }
}
