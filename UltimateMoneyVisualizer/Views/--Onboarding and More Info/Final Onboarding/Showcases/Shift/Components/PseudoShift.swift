//
//  PseudoShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import Foundation
import Vin

// MARK: - PseudoShift

struct PseudoShift: Hashable {
    var startTime: Date
    var endTime: Date
    var hourlyWage: Double

    // Computed property to calculate duration in hours
    var duration: Double {
        endTime - startTime // Converts seconds to hours
    }

    // Computed property to calculate total amount earned
    var totalAmountEarned: Double {
        duration / 60 / 60 * hourlyWage
    }

    // Function to generate pseudo shifts
    static func generatePseudoShifts(hourlyWage: Double, numberOfShifts: Int) -> [PseudoShift] {
        var shifts: [PseudoShift] = []

        for i in 0 ..< numberOfShifts {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -i, to: Date())!
            let startHour = (i % 2 == 0) ? 9 : 10
            let startMinute = (i % 2 == 0) ? 0 : 30
            let startTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: yesterday)!
            let endTime = calendar.date(byAdding: .hour, value: 8, to: startTime)!

            let shift = PseudoShift(startTime: startTime, endTime: endTime, hourlyWage: hourlyWage)
            shifts.append(shift)
        }

        return shifts
    }
    
    static let oneExample: PseudoShift = .generatePseudoShifts(hourlyWage: 20, numberOfShifts: 1).first!
}
