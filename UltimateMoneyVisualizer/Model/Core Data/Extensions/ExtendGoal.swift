//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

public extension Goal {
    @discardableResult convenience init(title: String, info: String?, amount: Double, dueDate: Date?, user: User, context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.id = UUID()
        self.user = user

        let currentQueueCount = Int16(user.getGoals().count) + Int16(user.getExpenses().count)
        // Put the item at the back of the queue at first initialization
        self.queueSlotNumber = Int16(currentQueueCount)

        try context.save()
    }
}

// MARK: - Goal + PayoffItem

extension Goal: PayoffItem {
    public func getID() -> UUID {
        if let id { return id }
        let newID = UUID()
        id = newID

        try? managedObjectContext?.save()

        return newID
    }
}

public extension Goal {
    static func makeExampleGoals(user: User, context: NSManagedObjectContext) throws {
//        try Goal(title: "Get a basketball", info: "For playing", amount: 7, dueDate: .now.addDays(7), user: user, context: context)
        try Goal(title: "New car fund", info: "Saving up for a down payment on a new car", amount: 10_000, dueDate: Date().addingTimeInterval(31_536_000), user: user, context: context)
        try Goal(title: "Vacation to Hawaii", info: "Planning a trip to Hawaii with my family", amount: 5_000, dueDate: Date().addingTimeInterval(157_680_000), user: user, context: context)
        try Goal(title: "Emergency fund", info: "Saving up for unexpected expenses", amount: 2_000, dueDate: nil, user: user, context: context)
        try Goal(title: "Home renovations", info: "Renovating my kitchen and bathroom", amount: 15_000, dueDate: Date().addingTimeInterval(63_072_000), user: user, context: context)
        try Goal(title: "College fund for kids", info: "Saving up for my kids' college education", amount: 50_000, dueDate: Date().addingTimeInterval(630_720_000), user: user, context: context)
        try Goal(title: "Retirement fund", info: "Planning for retirement", amount: 100_000, dueDate: nil, user: user, context: context)
        try Goal(title: "Business venture", info: "Investing in a new business opportunity", amount: 25_000, dueDate: Date().addingTimeInterval(157_680_000), user: user, context: context)
    }
}

public extension Goal {
    static let disneyWorld: Goal = {
        let goal = Goal(context: PersistenceController.context)
        goal.amount = 2_329
        goal.dateCreated = .now
        goal.dueDate = .now.addDays(278)
        goal.title = "Disney World"
        goal.info = "with Noah boy"
        let user = User(context: PersistenceController.context)
        user.username = "some user name"
        user.email = "vinnie@vinnie.vin"
        goal.user = user
        return goal
    }()

    func saveImage(image: UIImage) throws {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            self.imageData = imageData

            guard let context = user?.managedObjectContext else {
                throw NSError(domain: "No context found", code: 99)
            }
            try context.save()

        } else {
            throw NSError(domain: "Error converting image to data", code: 99)
        }
    }

    func getArrayOfTemporaryAllocations() -> [TemporaryAllocation] {
        guard let temporaryAllocations = temporaryAllocations?.allObjects as? [TemporaryAllocation] else {
            return []
        }
        return temporaryAllocations
    }

    func getMostRecentTemporaryAllocation() -> TemporaryAllocation? {
        let tempAllocsArray = getArrayOfTemporaryAllocations()

        let sorted = tempAllocsArray.sorted { ($0.lastEdited ?? .now) > ($1.lastEdited ?? .now) }


        return sorted.first
    }

    var percentTemporarilyPaidOff: Double {
        temporarilyPaidOff / amount
    }

    func loadImageIfPresent() -> UIImage? {
        if let imageData {
            return UIImage(data: imageData)
        }
        return nil
    }

    var temporarilyPaidOff: Double {
        guard let temporaryAllocations = temporaryAllocations as? Set<TemporaryAllocation>
        else {
            return 0
        }

        let totalTemporaryAllocated = temporaryAllocations.reduce(Double(0)) { $0 + $1.amount }

        return totalTemporaryAllocated + amountPaidOff
    }

    var temporaryRemainingToPayOff: Double {
        amount - temporarilyPaidOff
    }

    var titleStr: String { title ?? "Unknown Expense" }

    var amountMoneyStr: String {
        return amount.formattedForMoney(includeCents: true)
    }

    var amountPaidOff: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalTime: TimeInterval {
        guard let dateCreated, let dueDate else { return 0 }
        return dueDate - dateCreated
    }

    var timeRemaining: TimeInterval {
        guard let dueDate else { return 0 }
        return dueDate - .now
    }

    var percentPaidOff: Double {
        amountPaidOff / amount
    }

    var amountRemainingToPayOff: Double { return amount - amountPaidOff }
}
