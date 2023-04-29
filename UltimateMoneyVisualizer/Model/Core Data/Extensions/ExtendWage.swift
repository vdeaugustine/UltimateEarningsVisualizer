//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

extension Wage {
    
    var hourly: Double {
        amount
    }
    
    var secondly: Double {
        amount / 60 / 60
    }
    
    
    
}
