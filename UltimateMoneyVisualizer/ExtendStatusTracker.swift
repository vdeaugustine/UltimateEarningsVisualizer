//
//  ExtendStatusTracker.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import Foundation
import CoreData


public extension StatusTracker {
    @discardableResult
    convenience init(user: User, context: NSManagedObjectContext) throws  {
        self.init(context: context)
        self.user = user
        
        
        try context.save()
    }
    
    
    
    
    
}
