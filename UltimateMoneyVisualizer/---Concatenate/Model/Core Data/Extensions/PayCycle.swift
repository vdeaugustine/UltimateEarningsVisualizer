//
//  PayCycle.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import CoreData
import Foundation

public enum PayCycle: String, CaseIterable, Hashable, Identifiable {
    case daily
    case weekly
    case biWeekly = "Bi-Weekly"
    case monthly

    /// For identifiable
    public var id: PayCycle { self }

    var days: Double {
        switch self {
            case .daily:
                return 1
            case .weekly:
                return 7
            case .biWeekly:
                return 14
            case .monthly:
                return 28
        }
    }

    func nextPayDay(from date: Date? = .now) -> Date? {
        guard let date else { return nil }
        return date.addDays(days)
    }
}
