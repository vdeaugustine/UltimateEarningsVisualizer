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

        if exampleItem {
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
                return try User(exampleItem: true, viewContext: viewContext)
            }
        } catch {
            fatalError("Error retrieving or creating main user: \(error)")
        }
    }

    func totalEarned() -> Double {
        guard let wage else { return 0 }
        let totalDuration = totalTimeWorked()
        let hourlyRate = wage.amount
        let secondlyRate = hourlyRate / 60 / 60
        return totalDuration * secondlyRate
    }

    func getShiftsBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Shift] {
        let filteredShifts = getShifts().filter { shift in
            (shift.start >= startDate && shift.start <= endDate) || // Shift starts within the range
                (shift.end >= startDate && shift.end <= endDate) || // Shift ends within the range
                (shift.start <= startDate && shift.end >= endDate) || // Shift spans the entire range
                (shift.start <= startDate && shift.end >= startDate) || // Shift starts before the range and ends within the range
                (shift.start <= endDate && shift.end >= endDate) // Shift starts within the range and ends after the range
        }
        return filteredShifts
    }

    func getExpensesBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Expense] {
        let filteredExpenses = getExpenses().filter { expense in
            guard let date = expense.dateCreated else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredExpenses
    }
    
    
    func getSavedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Saved] {
        let filteredSaved = getSaved().filter { saved in
            guard let date = saved.date else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredSaved
    }
    
    func getAmountSavedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let saved = getSavedBetween(startDate: startDate, endDate: endDate)
        return saved.reduce(Double.zero, {$0 + $1.amount})
    }
    
    func getTimeSavedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> TimeInterval {
        getAmountSavedBetween(startDate: startDate, endDate: endDate) / getWage().perSecond
    }
    
    
    func getExpensesSpentBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let expenses = getExpensesBetween(startDate: startDate, endDate: endDate)
        return expenses.reduce(Double.zero, {$0 + $1.amount})
    }
    
    /// Returns the amount of seconds the given amount of money translates to
    func convertMoneyToTime(money: Double) -> TimeInterval {
        money / getWage().perSecond
    }
    

    func getTimeWorkedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> TimeInterval {
        let shifts = getShiftsBetween(startDate: startDate, endDate: endDate)
        return shifts.reduce(TimeInterval.zero) { $0 + $1.duration }
    }

    func getTotalEarnedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let timeWorked = getTimeWorkedBetween(startDate: startDate, endDate: endDate)
        return timeWorked * getWage().perSecond
    }

    func totalTimeWorked() -> TimeInterval {
        let shifts = getShifts()
        return shifts.reduce(TimeInterval.zero) { $0 + $1.duration }
    }

    /// Returns an array of the user's shifts. If the shifts set is nil, returns an empty array.
    ///
    /// - Returns: An array of the user's shifts.
    func getShifts() -> [Shift] {
        guard let shifts,
              let array = Array(shifts) as? [Shift] else { return [] }

        return array.sorted(by: {$0.start > $1.start})
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

    func getQueue() -> [PayoffItem] {
        var anyArr: [PayoffItem] = []

        anyArr += getExpenses()
        anyArr += getGoals()

        anyArr.sort { $0.queueSlotNumber < $1.queueSlotNumber }

        return anyArr
    }

    func getItemWith(queueSlot index: Int) -> PayoffItem? {
        getQueue().first(where: { $0.queueSlotNumber == Int16(index) })

//        getQueue().safeGet(at: index)
    }

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

    func getWage() -> Wage {
        wage ?? (try! Wage(amount: 20, user: self, context: managedObjectContext ?? PersistenceController.context))
    }

    /// Measured in seconds
    func totalTimeSaved() -> Double {
        let savedAmount = totalDollarsSaved()
        let secondlyWage = getWage().secondly
        return savedAmount / secondlyWage
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
