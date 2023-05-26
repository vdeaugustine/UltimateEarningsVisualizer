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
    case semiMonthly = "Semi-Monthly"
    case monthly
    case quarterly
    case semiAnnually = "Semi-Annually"
    case annually
    case biAnnually = "Bi-Annually"
    case custom

    /// For identifiable
    public var id: PayCycle { self }

//    /// So the core data can convert its string property to and from a PayCycle
//    init?(raw: String) {
//        switch raw.lowercased() {
//            case "daily".lowercased(): self = .daily
//            case "weekly".lowercased(): self = .weekly
//            case "Bi-Weekly".lowercased(): self = .biWeekly
//            case "Semi-Monthly".lowercased(): self = .semiMonthly
//            case "monthly".lowercased(): self = .monthly
//            case "quarterly".lowercased(): self = .quarterly
//            case "Semi-Annually".lowercased(): self = .semiAnnually
//            case "annually".lowercased(): self = .annually
//            case "Bi-Annually".lowercased(): self = .biAnnually
//            default: return nil
//        }
//    }
    
    /// Number of days in between paychecks
//    var daysBetweenChecks: Double {
//        switch self {
//        case .daily:
//            1
//        case .weekly:
//            7
//        case .biWeekly:
//            14
//        case .semiMonthly:
//            14
//        case .monthly:
//
//        case .quarterly:
//            <#code#>
//        case .semiAnnually:
//            <#code#>
//        case .annually:
//            <#code#>
//        case .biAnnually:
//            <#code#>
//        case .custom:
//            <#code#>
//        }
//    }
    
    
    
}
