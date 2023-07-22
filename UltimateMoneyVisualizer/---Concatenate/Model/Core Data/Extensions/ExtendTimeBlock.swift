//
//  ExtendTimeBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

extension TimeBlock {
    @discardableResult convenience init(title: String,
                                        start: Date,
                                        end: Date,
                                        colorHex: String,
                                        shift: Shift? = nil,
                                        todayShift: TodayShift? = nil,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        self.startTime = start
        self.endTime = end
        self.colorHex = colorHex
        self.user = user
        user.addToTimeBlocks(self)
        self.dateCreated = Date.now

        if let shift {
            self.shift = shift
            shift.addToTimeBlocks(self)
        }
        if let todayShift {
            self.todayShift = todayShift
            todayShift.addToTimeBlocks(self)
        }

        try context.save()
    }
}

extension TimeBlock {
    var duration: TimeInterval {
        guard let startTime, let endTime else { return 0 }
        return endTime - startTime
    }

    func amountEarned() -> Double {
        let user = self.user ?? User.main
        let perSecond = user.getWage().perSecond
        return duration * perSecond
    }

    func getColor() -> Color {
        guard let colorHex else { return Color(hex: "#003649") }
        return Color.hexStringToColor(hex: colorHex)
    }

    func getTitle() -> String {
        title ?? "UNKNOWN"
    }

    func getStartTimeString() -> String {
        startTime?.getFormattedDate(format: "h:mm") ?? "UNKNOWN"
    }

    func getEndTimeString() -> String {
        endTime?.getFormattedDate(format: .minimalTime) ?? "UNKNOWN"
    }

    func timeRangeString() -> String {
        guard let startTime, let endTime else { return "" }
        func areBothAMOrPM(date1: Date, date2: Date) -> Bool {
            let calendar = Calendar.current
            let hour1 = calendar.component(.hour, from: date1)
            let hour2 = calendar.component(.hour, from: date2)

            let day1 = calendar.component(.day, from: date1)
            let day2 = calendar.component(.day, from: date2)

            // Check if they are the same day
            guard day1 == day2 else {
                return false
            }

            // Hours from 0 to 11 are AM, and from 12 to 23 are PM.
            let isAM1 = hour1 < 12
            let isAM2 = hour2 < 12

            return isAM1 == isAM2
        }

        let firstStringFormat = areBothAMOrPM(date1: startTime, date2: endTime) ? "h:mm" : "h:mm a"

        let firstString = startTime.getFormattedDate(format: firstStringFormat)
        let secondString = endTime.getFormattedDate(format: .minimalTime)

        return "\(firstString) - \(secondString)"
    }
}
