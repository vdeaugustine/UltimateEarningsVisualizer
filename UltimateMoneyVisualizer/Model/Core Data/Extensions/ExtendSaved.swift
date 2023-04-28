//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

extension Saved {
    static func generateDummySavedItems(user: User) throws {
        let context = PersistenceController.context
        
        // Create a date formatter to format the date attribute of each saved item.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create some dummy saved items with interesting titles and descriptions.
        let savedItem1 = Saved(context: context)
        savedItem1.title = "Lunch at Home"
        savedItem1.amount = 5.0
        savedItem1.date = dateFormatter.date(from: "2023-04-27")
        savedItem1.info = "Didn't go out for lunch today, ate at home instead."
        savedItem1.user = user
        
        let savedItem2 = Saved(context: context)
        savedItem2.title = "Movie Night"
        savedItem2.amount = 12.5
        savedItem2.date = dateFormatter.date(from: "2023-04-28")
        savedItem2.info = "Watched a movie at home with friends instead of going to the theater."
        savedItem2.user = user
        
        let savedItem3 = Saved(context: context)
        savedItem3.title = "Cancelled Gym Membership"
        savedItem3.amount = 30.0
        savedItem3.date = dateFormatter.date(from: "2023-04-29")
        savedItem3.info = "Decided to cancel gym membership and do workouts at home."
        savedItem3.user = user
        
        // Save the context.
        try context.save()
    }

}
