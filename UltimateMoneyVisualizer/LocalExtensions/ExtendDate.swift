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
        if ["Su", "Sa", "Tu", "Th"].contains(firstTwoLetters) {
            return String(firstTwoLetters)
        } else {
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

    static func groupDatesByWeek(_ dates: [Date]) -> [[Date]] {
        var groupedDates: [[Date]] = []

        // Sort the dates in ascending order
        let sortedDates = dates.sorted()

        for date in sortedDates {
            if let lastWeek = groupedDates.last, let lastDate = lastWeek.last {
                // Check if the current date is in the same calendar week as the last date
                if Calendar.current.isDate(date, equalTo: lastDate, toGranularity: .weekOfYear) {
                    groupedDates[groupedDates.count - 1].append(date)
                } else {
                    groupedDates.append([date])
                }
            } else {
                groupedDates.append([date])
            }
        }

        return groupedDates
    }

    func getStartAndEndOfWeek() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        var startDate: Date = Date()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)

        // Calculate the start of the week by finding the first day (Sunday) of the week
        startDate = calendar.date(from: components)!

        // Calculate the end of the week by adding 6 days to the start date
        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!

        return (start: startDate, end: endDate)
    }
}
