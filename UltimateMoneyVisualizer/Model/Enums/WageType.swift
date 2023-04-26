//
//  WageType.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation

enum WageType: String, CaseIterable, Hashable, Identifiable {
    case hourly, salary
    var id: WageType { self }
}
