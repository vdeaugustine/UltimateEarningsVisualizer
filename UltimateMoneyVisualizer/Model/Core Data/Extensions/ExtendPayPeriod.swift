//
//  ExtendPayPeriod.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import Foundation
import CoreData
import Vin







public extension PayPeriod {
    
    
    @discardableResult convenience init(day: DayOfWeek, cycle: PayCycle, user: User, context: NSManagedObjectContext) throws {
        
        self.init(context: context)
        self.dayOfWeek = day.rawValue
        self.payCycle = cycle.rawValue
        self.firstDateEntered = .now
        
        try context.save()
        
        
    }
    
}
