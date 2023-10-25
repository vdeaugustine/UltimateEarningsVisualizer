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

// MARK: - CondensedTimeBlock

struct CondensedTimeBlock: Hashable, Identifiable, Comparable {
    let title: String
    let duration: TimeInterval
    let colorHex: String
    let lastUsed: Date

    
    func actualBlocks(_ user: User) -> [TimeBlock] {
        user.getTimeBlocks(withTitle: title).sorted(by: { ($0.endTime ?? .distantPast) > ($1.endTime ?? .distantPast) })
    }
    
    func actualBlocks(_ user: User, start: Date, end: Date) -> [TimeBlock] {
        user.getTimeBlocks(withTitle: title, startDate: start, endDate: end)
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.duration > rhs.duration
    }
    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.duration >= rhs.duration
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.duration < rhs.duration
    }
    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.duration <= rhs.duration
    }
    
    
    var color: Color { Color(hex: colorHex) }
    var id: Self { self }
}

// MARK: - TimeBlockKey

struct TimeBlockKey: Hashable {
    let title: String
    let colorHex: String
}

extension Array where Element == TimeBlock {

    func consolidate() -> [CondensedTimeBlock] {
        var retArr = [CondensedTimeBlock]()
        var blocksThatHaveBeenUsed = Set<String>()
        for block in self {
            let simpleTitle = block.getTitle().removingWhiteSpaces().lowercased()
            guard let user = block.user,
                  blocksThatHaveBeenUsed.contains(simpleTitle) == false
            else { continue }

            let thisBlockAndMatching: [TimeBlock] = user.getTimeBlocks(withTitle: block.getTitle()).sorted(by: {
                let firstEnd = $0.endTime ?? .distantPast
                let secondEnd = $1.endTime ?? .distantPast
                return firstEnd > secondEnd
            })
            let combinedDuration: Double = thisBlockAndMatching.reduce(Double.zero) { partialResult, nextBlock in
                partialResult + nextBlock.duration
            }
            
            let lastUsedBlock = thisBlockAndMatching.first ?? thisBlockAndMatching.first(where: { $0.endTime != nil })
            
            let condensed = CondensedTimeBlock(title: block.getTitle(),
                                               duration: combinedDuration,
                                               colorHex: block.getColor().getHex(),
                                               lastUsed: lastUsedBlock?.endTime ?? .now)
            retArr.append(condensed)
            blocksThatHaveBeenUsed.insert(simpleTitle)
        }
        return retArr.sorted(by: { $0.duration > $1.duration })
    }
}
