//
//  DayOfWeek.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation

public enum DayOfWeek: String, CaseIterable, Identifiable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    public var id: String { rawValue }
    
    static func getCurrentDayOfWeek() -> DayOfWeek {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: Date())
        
        return DayOfWeek(rawValue: dayOfWeekString.lowercased()) ?? .monday
    }
    
    init(date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayOfWeekString = dateFormatter.string(from: date)
            
            switch dayOfWeekString.lowercased() {
            case "sunday":
                self = .sunday
            case "monday":
                self = .monday
            case "tuesday":
                self = .tuesday
            case "wednesday":
                self = .wednesday
            case "thursday":
                self = .thursday
            case "friday":
                self = .friday
            case "saturday":
                self = .saturday
            default:
                self = .monday
            }
        }
}
