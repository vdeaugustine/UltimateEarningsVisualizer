//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import EventKit
import Foundation
import SwiftUI
import Vin

extension Settings {
    var themeColor: Color {
        get {
            if let str = themeColorStr {
                return Color(hex: str)
            }

            return Color("AccentColor")
        }

        set {
            let str = newValue.getHex()
            themeColorStr = str
            objectWillChange.send()
            do {
                try PersistenceController.context.save()
            } catch {
                print(error)
            }
        }
    }

    func getDefaultGradient(_ addValue: CGFloat? = nil) -> LinearGradient {
        LinearGradient(stops: [.init(color: themeColor,
                                     location: 0),
                               .init(color: themeColor.getLighterColorForGradient(addValue ?? 50),
                                     location: 1)],
                       startPoint: .bottom,
                       endPoint: .topLeading)
    }

    func getIncludedCalendarsIds() -> [String] {
        return includedCalendarsStringSeparatedByComma?.components(separatedBy: ",") ?? []
    }

    func convertListToString(_ list: [String]) -> String {
        return list.joined(separator: ",")
    }

    func saveCalendars(_ calendars: [EKCalendar]) throws {
        let stringsList = calendars.map { $0.calendarIdentifier }
        try saveIncludedCalendars(from: stringsList)
    }

    func saveIncludedCalendars(from idsList: [String]) throws {
        let string = convertListToString(idsList)
        includedCalendarsStringSeparatedByComma = string

        guard let context = managedObjectContext else {
            throw NSError(domain: "Problem getting context", code: 99)
        }
        try context.save()
    }

    func getCalendars() -> [EKCalendar] {
        let eventStore = EKEventStore()
        let identifiers = getIncludedCalendarsIds()
        var calendars: [EKCalendar] = []

        for identifier in identifiers {
            if let calendar = eventStore.calendar(withIdentifier: identifier) {
                calendars.append(calendar)
            }
        }

        return calendars
    }
}
