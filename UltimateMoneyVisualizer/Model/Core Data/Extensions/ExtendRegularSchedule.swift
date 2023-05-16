//
//  ExtendRegularSchedule.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import CoreData
import Foundation
import Vin

public extension RegularSchedule {
    @discardableResult convenience init(days: [RegularDay], user: User, context: NSManagedObjectContext? = nil) throws {
        let usingContext = context ?? user.getContext()

        self.init(context: usingContext)

        days.forEach { day in

            self.addToDays(day)
        }

        self.isActive = true

        user.regularSchedule = self
        self.user = user

        try usingContext.save()
    }

    /// Just for previews and testing. Will always set to 9am to 5pm
    @discardableResult convenience init(_ days: [DayOfWeek], user: User, context: NSManagedObjectContext) {
        let startTime = Date.stringToDate("9:00")!
        let endTime = Date.stringToDate("17:00")!

        let regularDays = days.map {
            let x = RegularDay(dayOfWeek: $0,
                               startTime: startTime,
                               endTime: endTime,
                               user: user)

            return x
        }

        try! self.init(days: regularDays, user: user, context: context)

        try! context.save()
    }
}

public extension RegularSchedule {
    func getDays() -> [DayOfWeek] {
        guard let daysArr = Array(days ?? []) as? [RegularDay]
        else {
            return []
        }

        return daysArr.compactMap { $0.getDayOfWeek() }
    }

    func getRegularDays() -> [RegularDay] {
        guard let daysArr = Array(days ?? []) as? [RegularDay]
        else {
            return []
        }
        return daysArr.sorted { day1, day2 in
            let day1Val = day1.getDayOfWeek() ?? .sunday
            let day2Val = day2.getDayOfWeek() ?? .sunday
            return day1Val < day2Val
        }
    }
}
