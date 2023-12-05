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
    @discardableResult convenience init(days: [RegularDay],
                                        user: User,
                                        context: NSManagedObjectContext? = nil) throws {
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
    @discardableResult convenience init(_ days: [DayOfWeek],
                                        user: User,
                                        context: NSManagedObjectContext) {
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
    /// Days of the week that our Regular Days are on
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

    /// Checks regular schedule to see if today is one of the days of thew week in which the user has work
    func todayIsWorkday() -> Bool {
        getDays().contains(DayOfWeek(date: .now))
    }

    func getStartTime(for date: Date) -> Date? {
        guard let today = getRegularDays().first(where: { $0.getDayOfWeek() == DayOfWeek(date: date) })
        else { return nil }
        return today.getStartTime()
    }

    func getEndTime(for date: Date) -> Date? {
        guard let today = getRegularDays().first(where: { $0.getDayOfWeek() == DayOfWeek(date: date) })
        else { return nil }
        return today.getEndTime()
    }

    /// Checks if the current time is in the middle of a regular day work shift
    func isMidShiftRightNow() -> Bool {
        guard let regularDay = getRegularDays().first(where: { $0.getDayOfWeek() == DayOfWeek(date: .now) }),
              let start = regularDay.getStartTime(),
              let end = regularDay.getEndTime()
        else { return false }

        let nowIsAfterStart = Date.now >= start
        let nowIsBeforeEnd = Date.now <= end
        return nowIsAfterStart && nowIsBeforeEnd
    }

    func countDaysInTimeFrame(startDate: Date, endDate: Date) -> Int {
        getDays(from: startDate, to: endDate).count
    }

    func getDays(from firstDate: Date, to secondDate: Date) -> [Date] {
        var date = firstDate
        let daysInSchedule = getDays()
        var returningArray: [Date] = []

        while date <= secondDate {
            let dayOfWeek = DayOfWeek(date: date)
            if daysInSchedule.contains(dayOfWeek) {
                returningArray.append(date)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }

        return returningArray
    }

    func willEarn(from firstDate: Date, to secondDate: Date) -> Double {
        guard let user = user else { return 0 }
        var amount: Double = 0
//        let regularDays = getRegularDays()

        for date in getDays(from: firstDate, to: secondDate) {
            let dayOfWeek = DayOfWeek(date: date)
            guard let regularDayForThisDayOfWeek = getRegularDays().first(where: { $0.getDayOfWeek() == dayOfWeek })
            else { continue }
            let duration = regularDayForThisDayOfWeek.getDuration()
            amount += user.convertTimeToMoney(seconds: duration)
        }

        return amount
    }
}

extension RegularSchedule {
    override public var description: String {
        var strs: [String] = []

        for day in getRegularDays() {
            guard let dayOfWeek = day.getDayOfWeek(),
                  let startTime = day.startTime,
                  let endTime = day.endTime
            else { continue }
            strs.append("\(dayOfWeek.description): \(startTime) - \(endTime)")
        }

        return strs.reduce("Regular Schedule\n") {
            $0 + $1 + "\n"
        }
    }
}
