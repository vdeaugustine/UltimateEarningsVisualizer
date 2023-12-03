//
//  File.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import Foundation
import SwiftUI

// MARK: - Day

struct Day {
    var dayOfWeek: DayOfWeek
    var startTime: Date
    var endTime: Date
    var isConfirmed: Bool

    static var defaultWeekdays: [Day] = DayOfWeek.weekdays.map {
        Day(dayOfWeek: $0,
            startTime: .nineAM,
            endTime: .fivePM,
            isConfirmed: false)
    }
}

// MARK: - FinalOnboardingScheduleViewModel

class FinalOnboardingScheduleViewModel: ObservableObject {
    
    #if DEBUG
    static var testing: FinalOnboardingScheduleViewModel = .init()
    #endif 
    
    @Published var slideNumber: Int = 1
    
    var totalSlideCount: Int {
        userHasRegularSchedule ? 3 : 2
    }
    
    var slidePercentage: Double {
        Double(slideNumber) / Double(totalSlideCount)
    }
    
    @Published var userHasRegularSchedule: Bool = false 
    
    @Published var daysSelected: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday]

    @Published var daysToBeSet: [DayOfWeek] = []

    @Published var sameHoursDays: [DayOfWeek] = []

    @Published var mondayStartTime: Date = .nineAM
    @Published var mondayEndTime: Date = .fivePM
    @Published var tuesdayStartTime: Date = .nineAM
    @Published var tuesdayEndTime: Date = .fivePM
    @Published var wednesdayStartTime: Date = .nineAM.addHours(3)
    @Published var wednesdayEndTime: Date = .fivePM.addHours(-2)
    @Published var thursdayStartTime: Date = .nineAM
    @Published var thursdayEndTime: Date = .fivePM
    @Published var fridayStartTime: Date = .nineAM
    @Published var fridayEndTime: Date = .fivePM

    @Published var highlightedDay: DayOfWeek? = nil
    
    var buttonTitle: String {
        slideNumber < totalSlideCount ? "Continue" : "Confirm"
    }

    func toggleDaySelection(_ day: DayOfWeek) {
        daysSelected.insertOrRemove(element: day)
    }

    func toggleSameDaySelection(_ day: DayOfWeek) {
        sameHoursDays.insertOrRemove(element: day)
    }

    func getDaysSelectedExcept() -> [DayOfWeek] {
        return daysSelected.filter { $0 != highlightedDay }.sorted(by: <)
    }

    func getStartTime(for day: DayOfWeek) -> Date {
        switch day {
            case .monday:
                return mondayStartTime
            case .tuesday:
                return tuesdayStartTime
            case .wednesday:
                return wednesdayStartTime
            case .thursday:
                return thursdayStartTime
            case .friday:
                return fridayStartTime
            default:
                return Date()
        }
    }

    func getEndTime(for day: DayOfWeek) -> Date {
        switch day {
            case .monday:
                return mondayEndTime
            case .tuesday:
                return tuesdayEndTime
            case .wednesday:
                return wednesdayEndTime
            case .thursday:
                return thursdayEndTime
            case .friday:
                return fridayEndTime
            default:
                return Date()
        }
    }

    func setStartTime(for day: DayOfWeek, to time: Date) {
        switch day {
            case .monday:
                mondayStartTime = time
            case .tuesday:
                tuesdayStartTime = time
            case .wednesday:
                wednesdayStartTime = time
            case .thursday:
                thursdayStartTime = time
            case .friday:
                fridayStartTime = time
            default:
                break
        }
    }

    func setEndTime(for day: DayOfWeek, to time: Date) {
        switch day {
            case .monday:
                mondayEndTime = time
            case .tuesday:
                tuesdayEndTime = time
            case .wednesday:
                wednesdayEndTime = time
            case .thursday:
                thursdayEndTime = time
            case .friday:
                fridayEndTime = time
            default:
                break
        }
    }
}
