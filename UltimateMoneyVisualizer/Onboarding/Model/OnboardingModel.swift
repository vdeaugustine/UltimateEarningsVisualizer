//
//  OnboardingModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/26/23.
//

import Foundation
import SwiftUI

class OnboardingModel: ObservableObject {
    public static var shared: OnboardingModel = OnboardingModel()
    let backgroundColor: Color = .clear
    @Published var screenNumber: Int = 1
    @Published var daysSelected: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    @Published var mondayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var mondayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var tuesdayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var tuesdayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var wednesdayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var wednesdayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var thursdayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var thursdayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var fridayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var fridayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var saturdayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var saturdayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()
    @Published var sundayStartTime: Date = Date.getThisTime(hour: 9, minute: 0) ?? Date()
    @Published var sundayEndTime: Date = Date.getThisTime(hour: 17, minute: 0) ?? Date()

    @ObservedObject var user: User = User.main
    
    
    @Published var firstGoalTitle: String = ""
    @Published var firstGoalAmount: String = ""
    @Published var firstGoalDueDate: Date = .now.addDays(7)
    @Published var firstGoalInfo: String = ""

    func increaseScreenNumber() {
        withAnimation {
            screenNumber += 1
        }
    }

    func decreaseScreenNumber() {
        withAnimation {
            screenNumber += 1
        }
    }

    func getTimeString(for dayOfWeek: DayOfWeek) -> String {
        let startTime: Date
        let endTime: Date

        switch dayOfWeek {
            case .monday:
                startTime = mondayStartTime
                endTime = mondayEndTime
            case .tuesday:
                startTime = tuesdayStartTime
                endTime = tuesdayEndTime
            case .wednesday:
                startTime = wednesdayStartTime
                endTime = wednesdayEndTime
            case .thursday:
                startTime = thursdayStartTime
                endTime = thursdayEndTime
            case .friday:
                startTime = fridayStartTime
                endTime = fridayEndTime
            case .saturday:
                startTime = saturdayStartTime
                endTime = saturdayEndTime
            case .sunday:
                startTime = sundayStartTime
                endTime = sundayEndTime
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)

        return "\(startTimeString) - \(endTimeString)"
    }

    func getStartBinding(for dayOfWeek: DayOfWeek) -> Binding<Date> {
        switch dayOfWeek {
            case .monday:
                return Binding<Date>(get: { self.mondayStartTime },
                                     set: { self.mondayStartTime = $0 })
            case .tuesday:
                return Binding<Date>(get: { self.tuesdayStartTime },
                                     set: { self.tuesdayStartTime = $0 })
            case .wednesday:
                return Binding<Date>(get: { self.wednesdayStartTime },
                                     set: { self.wednesdayStartTime = $0 })
            case .thursday:
                return Binding<Date>(get: { self.thursdayStartTime },
                                     set: { self.thursdayStartTime = $0 })
            case .friday:
                return Binding<Date>(get: { self.fridayStartTime },
                                     set: { self.fridayStartTime = $0 })
            case .saturday:
                return Binding<Date>(get: { self.saturdayStartTime },
                                     set: { self.saturdayStartTime = $0 })
            case .sunday:
                return Binding<Date>(get: { self.sundayStartTime },
                                     set: { self.sundayStartTime = $0 })
        }
    }

    func getEndBinding(for dayOfWeek: DayOfWeek) -> Binding<Date> {
        switch dayOfWeek {
            case .monday:
                return Binding<Date>(get: { self.mondayEndTime },
                                     set: { self.mondayEndTime = $0 })
            case .tuesday:
                return Binding<Date>(get: { self.tuesdayEndTime },
                                     set: { self.tuesdayEndTime = $0 })
            case .wednesday:
                return Binding<Date>(get: { self.wednesdayEndTime },
                                     set: { self.wednesdayEndTime = $0 })
            case .thursday:
                return Binding<Date>(get: { self.thursdayEndTime },
                                     set: { self.thursdayEndTime = $0 })
            case .friday:
                return Binding<Date>(get: { self.fridayEndTime },
                                     set: { self.fridayEndTime = $0 })
            case .saturday:
                return Binding<Date>(get: { self.saturdayEndTime },
                                     set: { self.saturdayEndTime = $0 })
            case .sunday:
                return Binding<Date>(get: { self.sundayEndTime },
                                     set: { self.sundayEndTime = $0 })
        }
    }
}
