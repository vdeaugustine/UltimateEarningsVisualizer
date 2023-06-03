//
//  ExtendTimeBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import Foundation
import CoreData
import Vin

extension TimeBlock {
    
    
    var duration: TimeInterval {
        guard let startTime, let endTime else { return 0 }
        return endTime - startTime
    }
    
    func amountEarned() -> Double {
        let perSecond = User.main.getWage().perSecond
        return duration * perSecond
    }
    
}
