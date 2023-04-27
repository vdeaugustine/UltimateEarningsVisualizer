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

        // Create some dummy saved items.
        let savedItem1 = Saved(context: context)
        savedItem1.title = "Dummy Saved Item 1"
        savedItem1.amount = 20.0
        savedItem1.date = dateFormatter.date(from: "2023-04-27")
        savedItem1.user = user

        let savedItem2 = Saved(context: context)
        savedItem2.title = "Dummy Saved Item 2"
        savedItem2.amount = 15.0
        savedItem2.date = dateFormatter.date(from: "2023-04-28")
        savedItem2.user = user

        let savedItem3 = Saved(context: context)
        savedItem3.title = "Dummy Saved Item 3"
        savedItem3.amount = 10.0
        savedItem3.date = dateFormatter.date(from: "2023-04-29")
        savedItem3.user = user

        try context.save()
    }
}
