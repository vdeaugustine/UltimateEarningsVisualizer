//
//  ExtendDate.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/5/23.
//

import Foundation

extension Date {
    func firstLetterOrTwoOfWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        let dayOfWeek = formatter.string(from: self)
        let firstTwoLetters = dayOfWeek.prefix(2)
        formatter.dateFormat = "E"
        let oneLetterDay = formatter.string(from: self)
        let firstLetter = oneLetterDay.prefix(1)
        if ["Su","Sa","Tu","Th"].contains(firstTwoLetters) {
            return String(firstTwoLetters)
        }
        else {
            return String(firstLetter)
        }
    }
    
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }

}
