//
//  ExtendDate.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/5/23.
//

import Foundation

public extension Date {
    func firstLetterOrTwoOfWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        let dayOfWeek = formatter.string(from: self)
        let firstTwoLetters = dayOfWeek.prefix(2)
        formatter.dateFormat = "E"
        let oneLetterDay = formatter.string(from: self)
        let firstLetter = oneLetterDay.prefix(1)
        if ["Su","Sa","Tu","Th"].contains(firstTwoLetters) {
            return String(firstTwoLetters)
        }
        else {
            return String(firstLetter)
        }
    }
    
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    
    /// This was created for Regular Schedules
    static func stringToDate(_ timeString: String, timeFormat: String = "H:mm", of thisDate: Date = .now) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = timeFormat
        guard let time = timeFormatter.date(from: timeString) else {
            return nil
        }

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        guard let hour = timeComponents.hour, let minute = timeComponents.minute else {
            return nil
        }

        var currentDayComponents = calendar.dateComponents([.year, .month, .day], from: thisDate)
        currentDayComponents.hour = hour
        currentDayComponents.minute = minute

        return calendar.date(from: currentDayComponents)
    }

}
