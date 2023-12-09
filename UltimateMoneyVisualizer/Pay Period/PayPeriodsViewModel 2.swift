//
//  PayPeriodsViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/6/23.
//

import Foundation
import SwiftUI

class PayPeriodsViewModel: ObservableObject {
    @Published var user: User = .main
    
    @Published var payPeriods = User.main.getPayPeriods()
    
    
    // for design / testing right now
    func format(_ date: Date?) -> String {
        (date ?? .now).getFormattedDate(format: .abreviatedMonthAndMinimalTime)
    }
}

