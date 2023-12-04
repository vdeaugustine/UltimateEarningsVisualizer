//
//  WageType.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation

public enum WageType: String, CaseIterable, Hashable, Identifiable {
    case hourly, salary
    public var id: WageType { self }
}
