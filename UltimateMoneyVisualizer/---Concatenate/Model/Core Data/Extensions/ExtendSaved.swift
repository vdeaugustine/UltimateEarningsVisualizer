//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import Vin

public extension Saved {
    @discardableResult convenience init(amount: Double,
                                        title: String,
                                        info: String? = nil,
                                        date: Date,
                                        tagStrings: [String]? = nil,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.amount = amount
        self.title = title
        self.info = info
        self.date = date
        self.user = user

        if let tagStrings {
            for tagStr in tagStrings {
                if let existingTag = user.getTags().first(where: { $0.getTitle() == tagStr }) {
                    existingTag.addToSavedItems(self)
                    addToTags(existingTag)
                    continue
                } else {
                    try Tag(tagStr, symbol: nil, savedItem: self, user: user, context: context)
                }
            }
        }

        try context.save()
    }
}

public extension Saved {
    func getDate() -> Date {
        date ?? .now.addDays(-10)
    }

    func getTitle() -> String {
        title ?? "Unknown Title"
    }

    func getAmount() -> Double {
        amount
    }

    func goalsAllocatedTo() -> [Goal] {
        let allocations = getAllocations()

        let goals = allocations.compactMap { $0.goal }
        let asSet = Set(goals)

        return Array(asSet)
    }

    func expensesAllocatedTo() -> [Expense] {
        let allocations = getAllocations()

        let expenses = allocations.compactMap { $0.expense }
        let asSet = Set(expenses)

        return Array(asSet)
    }

    func getPayoffItemsAllocatedTo() -> [PayoffItem] {
        let expenses = expensesAllocatedTo()
        let goals = goalsAllocatedTo()
        let combined: [PayoffItem] = goals + expenses

        return combined.sorted(by: { self.amountAllocated(for: $0) > self.amountAllocated(for: $1) })
    }

    func amountAllocated(for payoffItem: PayoffItem) -> Double {
        var sum: Double = 0

        for alloc in getAllocations() {
            var id: UUID?
            if let goal = alloc.goal {
                id = goal.id
            } else if let expense = alloc.expense {
                id = expense.id
            }

            if let id,
               id == payoffItem.getID() {
                sum += alloc.amount
            }
        }

        return sum
    }

    func getTags() -> [Tag] {
        if let tagsArray = tags?.allObjects as? [Tag] {
            return tagsArray
        }
        return []
    }

    var totalAllocated: Double {
        let allocations = getAllocations()
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalAvailable: Double {
        amount - totalAllocated
    }

    var percentSpent: Double {
        (totalAllocated / amount).roundTo(places: 1)
    }

    func getAllocations() -> [Allocation] {
        guard let allocations = allocations?.allObjects as? [Allocation] else {
            return []
        }

        return allocations
    }

    func amountForAllInstances(user: User) -> Double {
        user.getInstancesOf(savedItem: self)
            .reduce(Double.zero) { partialResult, saved in
                partialResult + saved.amount
            }
    }

    static func makeExampleSavedItems(user: User, context: NSManagedObjectContext) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        try Saved(amount: 5.0,
                  title: "Lunch at Home",
                  info: "Didn't go out for lunch today, ate at home instead.",
                  date: Date.now.addDays(Double.random(in: -3 ... 0)),
                  tagStrings: Tag.getSomeTitles(),
                  user: user,
                  context: context)

        try Saved(amount: 12.5,
                  title: "Movie Night",
                  info: "Watched a movie at home with friends instead of going to the theater.",
                  date: Date.now.addDays(Double.random(in: -3 ... 0)),
                  tagStrings: Tag.getSomeTitles(),
                  user: user,
                  context: context)

        try Saved(amount: 30.0,
                  title: "Cancelled Gym Membership",
                  info: "Decided to cancel gym membership and do workouts at home.",
                  date: Date.now.addDays(Double.random(in: -3 ... 0)),
                  tagStrings: Tag.getSomeTitles(),
                  user: user,
                  context: context)

        try Saved(amount: 5.0,
                  title: "Lunch at Home",
                  info: "Didn't go out for lunch today, ate at home instead.",
                  date: Date.now.addDays(-5),
                  tagStrings: Tag.getSomeTitles(),
                  user: user,
                  context: context)

        try context.save()
    }

    static func getExampleTitleAndDescription() -> (title: String, info: String) {
        let moneySavingIdeasInfo = ["Skipped buying coffee",
                                    "Made lunch at home",
                                    "Used public transportation instead of driving",
                                    "Canceled unused subscriptions",
                                    "Bought generic brands instead of name brands",
                                    "Brought reusable water bottle instead of buying bottled water",
                                    "Took advantage of discounts and coupons",
                                    "Switched to energy-efficient light bulbs",
                                    "Used a programmable thermostat to save on heating and cooling costs",
                                    "Opted for DIY home repairs and maintenance",
                                    "Cut down on dining out",
                                    "Sold items you no longer need",
                                    "Implemented a budget and tracked expenses",
                                    "Used cashback and rewards credit cards",
                                    "Shopped during sales and clearance events",
                                    "Reduced impulse purchases",
                                    "Cut down on unused gym memberships or services",
                                    "Biked or walked instead of using a car for short trips",
                                    "Switched to a more affordable phone plan",
                                    "Switched to a cheaper internet or cable TV plan",
                                    "Installed energy-efficient appliances",
                                    "Participated in clothing swaps with friends",
                                    "Reused and repurposed items instead of buying new",
                                    "Started a side hustle or freelance work",
                                    "Participated in community events and free activities",
                                    "Took advantage of employer benefits and discounts"]

        let moneySavingIdeasTitle = ["Instead of buying at Starbucks",
                                     "Instead of going out to eaat",
                                     "Use public transportation",
                                     "Cancel unused subscriptions",
                                     "Buy generic brands",
                                     "Use reusable water bottle",
                                     "Apply discounts and coupons",
                                     "Switch to LED bulbs",
                                     "Programmable thermostat",
                                     "Try DIY home repairs",
                                     "Cut down dining out",
                                     "Sell unused items",
                                     "Budget and track expenses",
                                     "Cashback credit cards",
                                     "Shop during sales",
                                     "Reduce impulse buys",
                                     "Avoid unused gym memberships",
                                     "Walk or bike short trips",
                                     "Affordable phone plan",
                                     "Cheaper internet or cable",
                                     "Energy-efficient appliances",
                                     "Clothing swaps with friends",
                                     "Reuse and repurpose items",
                                     "Start a side hustle",
                                     "Attend free community events",
                                     "Utilize employer discounts"]

        let int = Int.random(in: 0 ..< moneySavingIdeasInfo.count)
        return (title: moneySavingIdeasTitle.safeGet(at: int) ?? "Skip buying coffee",
                info: moneySavingIdeasInfo.safeGet(at: int) ?? "Instead of buying at Starbucks")
    }
}
