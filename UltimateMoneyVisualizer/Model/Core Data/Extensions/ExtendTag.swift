//
//  ExtendTag.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/22/23.
//

import CoreData
import Foundation

public extension Tag {
    
    @discardableResult convenience init(_ title: String, symbol: String?, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        let now = Date.now
        self.lastUsed = now
        self.dateCreated = now
        self.user = user
        user.addToTags(self)
        
        try context.save()
    }
    
    
    @discardableResult convenience init(_ title: String, symbol: String?, goal: Goal, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        addToGoals(goal)
        let now = Date.now
        self.lastUsed = now
        self.dateCreated = now
        self.user = user
        user.addToTags(self)
        
        try context.save()
    }

    @discardableResult convenience init(_ title: String, symbol: String?, expense: Expense, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        addToExpenses(expense)
        let now = Date.now
        self.lastUsed = now
        self.dateCreated = now
        try context.save()
    }

    @discardableResult convenience init(_ title: String, symbol: String?, savedItem: Saved, user: User, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        addToSavedItems(savedItem)
        let now = Date.now
        self.lastUsed = now
        self.dateCreated = now
        try context.save()
    }
}

public extension Tag {
    func getTitle() -> String {
        if let title {
            return title
        }
        return ""
    }

    func getDateCreated() -> Date {
        if let dateCreated {
            return dateCreated
        }
        let now = Date.now
        dateCreated = now
        try? managedObjectContext?.save()
        return now
    }

    func getLastUsed() -> Date {
        if let lastUsed {
            return lastUsed
        }
        let now = Date.now
        lastUsed = now
        try? managedObjectContext?.save()
        return now
    }
}

public extension Tag {
    static let someExampleTagTitles: [String] = ["Emergency Fund",
                                                 "Clothes",
                                                 "Debt",
                                                 "Retirement",
                                                 "Savings",
                                                 "Vacation",
                                                 "Home",
                                                 "New Car",
                                                 "Wedding",
                                                 "Education",
                                                 "Investment",
                                                 "Business",
                                                 "Charity",
                                                 "Tech Stuff",
                                                 "Personal",
                                                 "Luxury",
                                                 "Health & Fitness",
                                                 "Hobbies"]
    
    static func getSomeTitles(amount: Int? = nil) -> [String] {
        var options = Tag.someExampleTagTitles
        var returnedArray = [String]()
        let useAmount = amount ?? Int.random(in: 1 ..< 4)
        for _ in 0 ..< useAmount {
            let selected = options.remove(at: Int.random(in: 0 ..< options.count))
            returnedArray.append(selected)
        }
        return returnedArray
    }
}
