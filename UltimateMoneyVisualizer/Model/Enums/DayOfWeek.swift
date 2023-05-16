//
//  DayOfWeek.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation

public enum DayOfWeek: String, CaseIterable, Identifiable, Hashable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"

    public var dayNum: Int {
        switch self {
            case .sunday:
                return 7
            case .monday:
                return 1
            case .tuesday:
                return 2
            case .wednesday:
                return 3
            case .thursday:
                return 4
            case .friday:
                return 5
            case .saturday:
                return 8
        }
    }
    
    static var orderedCases: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    

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
    
    
    init?(fromString stringValue: String) {
        switch stringValue.lowercased() {
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
            return nil
        }
    }
    
    
    init(_ shift: Shift) {
        let day = shift.dayOfWeek ?? "monday"
        self = DayOfWeek(fromString: day) ?? DayOfWeek.monday
    }
    
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.dayNum > rhs.dayNum
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.dayNum < rhs.dayNum
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.dayNum <= rhs.dayNum
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.dayNum >= rhs.dayNum
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.dayNum == rhs.dayNum
    }
    
    

}
