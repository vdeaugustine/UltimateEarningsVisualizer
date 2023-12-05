//
//  ExtendRecurringTimeBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/14/23.
//

import CoreData
import EventKit
import Foundation
import SwiftUI
import Vin

public extension RecurringTimeBlock {
    @discardableResult convenience init(event: EKEvent,
                                        user: User,
                                        context: NSManagedObjectContext? = nil) throws {
        let usingContext = context ?? user.getContext()
        
        self.init(context: usingContext)
        
        self.title = event.title
        self.startTime = RecurringTimeBlock.convertDateComponentsToString(
            components: Calendar.current.dateComponents([.hour,
                                                         .minute],
                                                        from: event.startDate)
        )
        self.endTime = RecurringTimeBlock.convertDateComponentsToString(
            components: Calendar.current.dateComponents([.hour,
                                                         .minute],
                                                        from: event.endDate)
        )
        
        let color = Color(cgColor: event.calendar.cgColor)
        self.colorHex = color.getHex()
        if let eventRecurrenceRule = event.recurrenceRules?.first {
            self.recurrenceRule = eventRecurrenceRule.serialize()
        }
        user.addToRecurringTimeBlocks(self)
        
        self.user = user
        
        try usingContext.save()
    }
    
    func getRecurrenceRule() -> EKRecurrenceRule? {
        self.recurrenceRule?.deserializeEKRecurrenceRule()
    }
    
    func getColor() -> Color {
        Color(hex: self.colorHex ?? "FFFFFF")
    }

    // Convert DateComponents to String
    static func convertDateComponentsToString(components: DateComponents) -> String? {
        guard let hour = components.hour, let minute = components.minute else {
            return nil
        }

        let isPM = hour >= 12
        let adjustedHour = isPM ? (hour - 12) : hour
        let period = isPM ? "PM" : "AM"

        return String(format: "%02d:%02d %@", adjustedHour, minute, period)
    }

    // Convert String to DateComponents
    static func convertStringToDateComponents(timeString: String) -> DateComponents? {
        let timeComponents = timeString.split(separator: " ")
        guard timeComponents.count == 2, let period = timeComponents.last,
              let hourMinuteComponents = timeComponents.first?.split(separator: ":"),
              hourMinuteComponents.count == 2,
              let hour = Int(hourMinuteComponents[0]),
              let minute = Int(hourMinuteComponents[1]) else {
            return nil
        }

        var adjustedHour = hour

        if period == "PM" {
            adjustedHour += 12
        }

        return DateComponents(calendar: Calendar.current, timeZone: .current, hour: adjustedHour, minute: minute)
    }

    var startTimeComponents: DateComponents? {
        guard let startTime else { return nil }
        return RecurringTimeBlock.convertStringToDateComponents(timeString: startTime)
    }

    var endTimeComponents: DateComponents? {
        guard let endTime else { return nil }
        return RecurringTimeBlock.convertStringToDateComponents(timeString: endTime)
    }
}

// MARK: - Serializing

public extension EKRecurrenceRule {
    func serialize() -> Data? {
        var dict: [String: Any] = [:]

        dict["frequency"] = frequency.rawValue
        dict["interval"] = interval
        dict["occurrenceCount"] = recurrenceEnd?.occurrenceCount
        dict["endDate"] = recurrenceEnd?.endDate
        dict["calendarIdentifier"] = calendarIdentifier
        dict["firstDayOfTheWeek"] = firstDayOfTheWeek
        dict["daysOfTheWeek"] = daysOfTheWeek
        dict["daysOfTheMonth"] = daysOfTheMonth
        dict["daysOfTheYear"] = daysOfTheYear
        dict["weeksOfTheYear"] = weeksOfTheYear
        dict["monthsOfTheYear"] = monthsOfTheYear
        dict["setPositions"] = setPositions

        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
}

public extension Data {
    func deserializeEKRecurrenceRule() -> EKRecurrenceRule? {
        if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any],
           let frequencyRawValue = dict["frequency"] as? Int,
           let frequency = EKRecurrenceFrequency(rawValue: frequencyRawValue),
           let interval = dict["interval"] as? Int {
            
            var recurrenceEnd: EKRecurrenceEnd?
            if let occurrenceCount = dict["occurrenceCount"] as? Int {
                recurrenceEnd = EKRecurrenceEnd(occurrenceCount: occurrenceCount)
            } else if let endDate = dict["endDate"] as? Date {
                recurrenceEnd = EKRecurrenceEnd(end: endDate)
            }
            
            let daysOfTheWeek = dict["daysOfTheWeek"] as? [EKRecurrenceDayOfWeek]
            let daysOfTheMonth = dict["daysOfTheMonth"] as? [NSNumber]
            let daysOfTheYear = dict["daysOfTheYear"] as? [NSNumber]
            let weeksOfTheYear = dict["weeksOfTheYear"] as? [NSNumber]
            let monthsOfTheYear = dict["monthsOfTheYear"] as? [NSNumber]
            let setPositions = dict["setPositions"] as? [NSNumber]
            
            let rule = EKRecurrenceRule(
                recurrenceWith: frequency,
                interval: Swift.max(1, interval),
                daysOfTheWeek: daysOfTheWeek,
                daysOfTheMonth: daysOfTheMonth,
                monthsOfTheYear: monthsOfTheYear,
                weeksOfTheYear: weeksOfTheYear,
                daysOfTheYear: daysOfTheYear,
                setPositions: setPositions,
                end: recurrenceEnd
            )
            
            
            return rule
        }
        return nil
    }

}
