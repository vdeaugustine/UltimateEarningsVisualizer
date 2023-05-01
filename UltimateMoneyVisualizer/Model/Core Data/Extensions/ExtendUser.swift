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

public extension User {
    @discardableResult convenience init(exampleItem: Bool = true, viewContext: NSManagedObjectContext = PersistenceController.testing) throws {
        self.init(context: viewContext)
        self.username = "Testing User"
        self.email = "TestUser@ExampleForTest.com"

        let wage = Wage(context: viewContext)
        wage.amount = 20
        wage.user = self
        self.wage = wage

        do {
            // Make Goals
            try Goal.makeExampleGoals(user: self, context: viewContext)

            // Make Expenses
            try Expense.makeExampleExpenses(user: self, context: viewContext)

            // Make Shifts
            try Shift.makeExampleShifts(user: self, context: viewContext)

            // Make Saved items
            try Saved.makeExampleSavedItems(user: self, context: viewContext)

            // Make today shift
            try TodayShift.makeExampleTodayShift(user: self, context: viewContext)

            // Make temporary allocations
        } catch {
            fatalError(String(describing: error))
        }

        try viewContext.save()
    }

    static var testing: User {
        try! User(viewContext: PersistenceController.testing)
    }

    static var main: User {
        let viewContext = PersistenceController.context

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1

        do {
            let results = try viewContext.fetch(request)
            if let user = results.first {
                if user.todayShift != nil { return user }

                if let shiftThatIsToday = user.getTodayShift() {
                    let todayShift = TodayShift(context: viewContext)
                    todayShift.startTime = shiftThatIsToday.startDate
                    todayShift.endTime = shiftThatIsToday.endDate
                    todayShift.user = user
                    user.todayShift = todayShift
                }

                return user
            } else {
                return try User(exampleItem: false, viewContext: viewContext)
            }
        } catch {
            fatalError("Error retrieving or creating main user: \(error)")
        }
    }

    func totalEarned() -> Double {
        guard let wage else { return 0 }
        let totalDuration = Shift.totalDuration(for: self)
        let hourlyRate = wage.amount
        let secondlyRate = hourlyRate / 60 / 60
        return totalDuration * secondlyRate
    }

    func totalWorked() -> Double {
        Shift.totalDuration(for: self)
    }

    /// Returns an array of the user's shifts. If the shifts set is nil, returns an empty array.
    ///
    /// - Returns: An array of the user's shifts.
    func getShifts() -> [Shift] {
        guard let shifts,
              let array = Array(shifts) as? [Shift] else { return [] }

        return array
    }

    func getTodayShift() -> Shift? {
        let now = Date()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)

        guard let shifts = shifts, let allShifts = Array(shifts) as? [Shift] else { return nil }

        for shift in allShifts {
            guard let start = shift.startDate,
                  let end = shift.endDate else { continue }

            let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
            let endComponents = calendar.dateComponents([.year, .month, .day], from: end)

            if startComponents == todayComponents || endComponents == todayComponents {
                return shift
            }
        }

        return nil
    }

    var hasShiftToday: Bool { getTodayShift() != nil }

    func getExpenses() -> [Expense] {
        guard let expenses else { return [] }
        return Array(expenses) as? [Expense] ?? []
    }

    func getGoals() -> [Goal] {
        guard let goals else { return [] }
        return Array(goals) as? [Goal] ?? []
    }

    func getSaved() -> [Saved] {
        guard let savedItems else { return [] }
        return Array(savedItems) as? [Saved] ?? []
    }

    func totalDollarsSaved() -> Double {
        getSaved().reduce(Double(0)) { $0 + $1.getAmount() }
    }

    func getValidTodayShift() -> TodayShift? {
        guard let todayShift,
              let expiration = todayShift.expiration,
              let context = managedObjectContext
        else { return nil }

        let isExpired = Date.now >= expiration

        if isExpired {
            context.delete(todayShift)
            self.todayShift = nil
            return nil
        }

        return todayShift
    }

    func getSettings() -> Settings {
        if let settings {
            return settings
        }

        let newSettings = Settings(context: PersistenceController.context)
        newSettings.themeColorStr = Color.defaultColorHexes.first
        newSettings.user = self
        settings = newSettings
        do {
            try PersistenceController.context.save()
        } catch {
            print(error)
        }

        return newSettings
    }

    func expenseWithMostAllocations() -> Expense? {
        // Get the expense with the highest number of allocations

        guard let expensesArr = Array(expenses ?? []) as? [Expense] else {
            return nil
        }

        let expenseWithMostAllocations = expensesArr.sorted { expense1, expense2 in
            let count1 = (expense1.allocations ?? []).count
            let count2 = (expense2.allocations ?? []).count
            return count1 > count2
        }.first

        return expenseWithMostAllocations
    }
}
