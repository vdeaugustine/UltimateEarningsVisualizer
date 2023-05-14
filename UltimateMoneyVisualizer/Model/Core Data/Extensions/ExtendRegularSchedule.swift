//
//  ExtendRegularSchedule.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import Foundation
import CoreData
import Vin


public extension RegularSchedule {
    
    convenience init(days: [RegularDay], user: User, context: NSManagedObjectContext? = nil) throws {
        
        let usingContext = context ?? user.getContext()
        
        self.init(context: usingContext)
        
        days.forEach { day in
            self.addToDays(day)
        }

        self.isActive = true
        
        try usingContext.save()
        
    }
    
}

public extension RegularSchedule {
    
//    func setStartTime(_ time: Date) {
//        
//        
//        
//    }
    
    
    
    
}
