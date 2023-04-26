//
//  DayOfWeek.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation

enum DayOfWeek: String, CaseIterable, Identifiable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    var id: String { rawValue }
    
    static func getCurrentDayOfWeek() -> DayOfWeek {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: Date())
        
        return DayOfWeek(rawValue: dayOfWeekString.lowercased()) ?? .monday
    }
}
