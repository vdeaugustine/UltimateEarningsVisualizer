//
//  ExtendRegularDay.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import CoreData
import Foundation
import Vin



public extension RegularDay {
    /// Not set up to save when created. Not sure if we care if it does that yet
    convenience init(dayOfWeek: DayOfWeek, startTime: Date, endTime: Date, user: User, context: NSManagedObjectContext? = nil) {
        let dayString = dayOfWeek.rawValue
        let startString = startTime.getFormattedDate(format: .militaryTime)
        let endString = endTime.getFormattedDate(format: .militaryTime)

        self.init(context: context ?? user.getContext())
        self.dayName = dayString
        self.startTime = startString
        self.endTime = endString
        self.isActive = true
    }
}

// MARK: - RegularDay + Identifiable


public extension RegularDay {
    func getDayOfWeek() -> DayOfWeek? {
        guard let dayName else { return nil }
        return DayOfWeek(fromString: dayName)
    }
}
