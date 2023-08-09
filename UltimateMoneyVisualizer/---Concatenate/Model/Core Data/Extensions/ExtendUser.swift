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
    @discardableResult convenience init(exampleItem: Bool = true,
                                        context: NSManagedObjectContext = PersistenceController.testing) throws {
        self.init(context: context)
        self.username = "Testing User"
        self.email = "TestUser@ExampleForTest.com"

        try Wage(amount: 35,
                 isSalary: false,
                 user: self,
                 includeTaxes: true,
                 stateTax: 7,
                 federalTax: 19,
                 context: context)

        if exampleItem {
            do {
                // Make Pay Period Settings
                try PayPeriodSettings(cycleCadence: .weekly,
                                      autoGenerate: true,
                                      user: self,
                                      context: context)

                // Make Goals
                try Goal.makeExampleGoals(user: self, context: context)

                // Make Expenses
                try Expense.makeExampleExpenses(user: self, context: context)

                // Make Shifts
                try Shift.makeExampleShifts(user: self, context: context)

                // Make pay periods for existing shifts
                try PayPeriod.assignShiftsToPayPeriods()

                // Make Saved items
                try Saved.makeExampleSavedItems(user: self, context: context)

                // Make today shift
                try TodayShift.makeExampleTodayShift(user: self, context: context)

                // Set regular schedule
                RegularSchedule([.tuesday, .wednesday, .thursday],
                                user: self,
                                context: context)

                // Make Expenses that will not be allocated

                try Expense.makeExpensesThatWontBeAllocated(user: self, context: context)

            } catch {
                fatalError(String(describing: error))
            }
        }

        try context.save()
    }

    static var testing: User {
        User(context: PersistenceController.testing)
    }

    static func getTestingUserWithExamples() throws -> User {
        try User(exampleItem: true)
    }

    static var main: User {
        let userContext = PersistenceController.context

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1

        do {
            let results = try userContext.fetch(request)
            if results.count > 1 {
                fatalError("MORE THAN ONE USER")
            }

            // Get the user from the results
            if let user = results.first {
                try user.createRecurredExpenses()

                // If the user has a TodayShift
                if let existingTodayShift = user.todayShift,
                   let endOfToday = existingTodayShift.endTime {
                    // If the shift is from a previous day (so it is expired)
                    if endOfToday < Date.beginningOfDay() {
                        // We want to set todayShift to nil and not return that user
                        user.todayShift = nil
                    } else {
                        // Nothing else needs to be done so the user can be returned
                        return user
                    }
                }

                // Check if next pay period needs to be made
                if let payPeriodSettings = user.payPeriodSettings,
                   payPeriodSettings.autoGeneratePeriods {
                    if let mostRecent = user.getPayPeriods().first,
                       let lastDate = mostRecent.payDay,
                       Date.now >= lastDate {
                        try PayPeriod(firstDate: Date.endOfDay(lastDate).advanced(by: 1),
                                      settings: payPeriodSettings,
                                      user: user,
                                      context: userContext)
                    }
                }

                return user
            } else {
                return try User(exampleItem: true, context: userContext)
            }
        } catch {
            fatalError("Error retrieving or creating main user: \(error)")
        }
    }

    func getContext() -> NSManagedObjectContext {
        managedObjectContext ?? PersistenceController.context
    }

    // MARK: - Money Calculations

    /// Returns the amount of seconds the given amount of money translates to
    func convertMoneyToTime(money: Double) -> TimeInterval {
        money / getWage().perSecond
    }
    
    func convertTimeToMoney(seconds: TimeInterval) -> Double {
        getWage().perSecond * seconds
    }

    // MARK: - Wage and Money

    func getWage() -> Wage {
        wage ?? (try! Wage(amount: 20,
                           isSalary: false,
                           user: self,
                           includeTaxes: false,
                           stateTax: nil,
                           federalTax: nil,
                           context: managedObjectContext ?? PersistenceController.context)
        )
    }

    func totalEarned() -> Double {
        guard let wage else { return 0 }

        if wage.isSalary {
            return getShifts().reduce(Double.zero) { partialResult, shift in
                partialResult + shift.totalEarned
            }
        } else {
            return totalTimeWorked() * wage.perSecond
        }
    }

    func totalSpent() -> Double {
        let expenses = getAmountForAllExpensesBetween()
        let goals = getAmountForAllGoalsBetween()
        return expenses + goals
    }

    func totalNetMoneyBetween(_ startDate: Date = .distantPast, _ endDate: Date = .distantFuture) -> Double {
        // Total net money should be this formula
        // Earned + Saved - (AllocatedUpToThisDay)
        let earned = getTotalEarnedBetween(startDate: startDate, endDate: endDate)
        let amountSaved = getAmountSavedBetween(startDate: startDate, endDate: endDate)
        let expenses = getAmountForAllExpensesBetween(startDate: startDate, endDate: endDate)
        let goals = getAmountForAllGoalsBetween(startDate: startDate, endDate: endDate)

        return (earned + amountSaved) - (expenses + goals)
    }

    // MARK: - Shifts

    /// Returns an array of the user's shifts. If the shifts set is nil, returns an empty array.
    ///
    /// - Returns: An array of the user's shifts.
    func getShifts() -> [Shift] {
        guard let shifts, let array = Array(shifts) as? [Shift] else { return [] }
        return array.sorted(by: { $0.start > $1.start })
    }

    /// Retrieves the shift happening today from a collection of shifts.
    /// - Returns: The shift object that matches the current day, or nil if no shift is found or an error occurs.
    func getShiftOnToday() -> Shift? {
        // Get the current date and time
        let now = Date()

        // Create a Calendar instance
        let calendar = Calendar.current

        // Extract the year, month, and day components from the current date
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)

        // Check if shifts variable is not nil and can be converted to an array of Shift objects
        guard let shifts = shifts, let allShifts = Array(shifts) as? [Shift] else {
            return nil // Return nil if shifts is nil or cannot be converted to an array of Shift objects
        }

        // Iterate through each shift
        for shift in allShifts {
            // Check if the shift has both startDate and endDate
            guard let start = shift.startDate, let end = shift.endDate else {
                continue // Skip to the next iteration if startDate or endDate is nil
            }

            // Extract the year, month, and day components from the start and end dates
            let startComponents = calendar.dateComponents([.year, .month, .day], from: start)
            let endComponents = calendar.dateComponents([.year, .month, .day], from: end)

            // Check if the startComponents or endComponents match the todayComponents
            if startComponents == todayComponents || endComponents == todayComponents {
                return shift // Return the shift if it matches the current day
            }
        }

        return nil // Return nil if no shift matches the current day
    }

    var hasShiftToday: Bool { getShiftOnToday() != nil }

    func getDuplicateShifts() -> [Shift] {
        let shifts = getShifts()

        var duplicates = [Shift]()
        var checkedShifts = Set<Shift>()

        for shift in shifts {
            if checkedShifts.contains(where: { $0.start == shift.start && $0.end == shift.end }) {
                duplicates.append(shift)
            } else {
                checkedShifts.insert(shift)
            }
        }

        return duplicates
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

    // MARK: Shifts - Time Blocks

    func getTimeBlocksBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [TimeBlock] {
        let shifts = getShiftsBetween(startDate: startDate, endDate: endDate)

        return shifts.flatMap { $0.getTimeBlocks() }
    }

    func getTimeBlocks(withTitle title: String, startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [TimeBlock] {
        let simpleTitle = title.lowercased().removingWhiteSpaces()
        return getTimeBlocksBetween(startDate: startDate, endDate: endDate)
            .filter { block in
                let blockSimpleTitle = block.getTitle().lowercased().removingWhiteSpaces()
                return blockSimpleTitle == simpleTitle
            }
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

    // MARK: - Settings

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

    // MARK: - Allocations

    func getExpenseAllocations() -> [Allocation] {
        getAllocations().filter( {$0.payoffType == .expense })
    }

    func getGoalAllocations() -> [Allocation] {
        getAllocations().filter({ $0.payoffType == .goal })
    }

    func getAllocations() -> [Allocation] {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return [] }
        return allocations.sorted(by: { $0.date ?? .distantPast > $1.date ?? .distantPast })
    }

    func amountAllocated() -> Double {
        getAllocations().reduce(Double.zero) { $0 + $1.amount }
    }
    
    func amountAllocatedToGoals() -> Double {
        getGoalAllocations().reduce(Double.zero, { $0 + $1.amount })
    }
    
    func amountAllocatedToExpenses() -> Double {
        getExpenseAllocations().reduce(Double.zero, { $0 + $1.amount })
    }


    // MARK: - Expenses

    func getExpenses() -> [Expense] {
        guard let expenses else { return [] }
        return Array(expenses) as? [Expense] ?? []
    }

    func getExpensesBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Expense] {
        let filteredExpenses = getExpenses().filter { expense in
            guard let date = expense.dueDate else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredExpenses
    }

    func getAmountForAllExpensesBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let expenses = getExpensesBetween(startDate: startDate, endDate: endDate)
        return expenses.reduce(Double.zero) { $0 + $1.amount }
    }
    
    func getUnfinishedExpenses(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Expense] {
        getExpensesBetween(startDate: startDate, endDate: endDate).filter({ $0.isPaidOff == false })
    }
    
    func getAmountRemainingToPay_Expenses() -> Double {
        getUnfinishedExpenses().reduce(Double.zero, { $0 + $1.amountRemainingToPayOff })
    }
    
    func getAmountActuallySpentOnExpenses(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let expenses = getExpensesBetween(startDate: startDate, endDate: endDate)
        return expenses.reduce(Double.zero) { $0 + $1.amountPaidOff }
    }

    func getInstancesOf(expense: Expense) -> [Expense] {
        let filtered = getExpenses().filter { thisExpense in
            thisExpense.titleStr == expense.titleStr
        }
        return filtered
    }

    func getExpensesWith(tag: Tag) -> [Expense] {
        let filtered = getExpenses().filter { expense in
            expense.getTags().contains(where: { expenseTag in
                expenseTag == tag
            })
        }
        return filtered
    }

    func expenseWithMostAllocations() -> Expense? {
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

    // MARK: - Goals

    func getGoals() -> [Goal] {
        guard let goals else { return [] }
        return Array(goals) as? [Goal] ?? []
    }
    
    func getUnfinishedGoals(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Goal] {
        getGoalsBetween(startDate: startDate, endDate: endDate).filter({ $0.isPaidOff == false })
    }
    
    func getAmountRemainingToPay_Goals() -> Double {
        getUnfinishedGoals().reduce(Double.zero, { $0 + $1.amountRemainingToPayOff })
    }

    func getGoalsBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Goal] {
        let filteredGoals = getGoals().filter { goal in
            guard let date = goal.dateCreated else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredGoals
    }

    func getAmountForAllGoalsBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let goals = getGoalsBetween(startDate: startDate, endDate: endDate)
        return goals.reduce(Double.zero) { $0 + $1.amount }
    }
    
    func getAmountActuallySpentOnGoals(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let goals = getGoalsBetween(startDate: startDate, endDate: endDate)
        return goals.reduce(Double.zero) { $0 + $1.amountPaidOff }
    }

    func getInstancesOf(goal: Goal) -> [Goal] {
        let filtered = getGoals().filter { thisGoal in
            thisGoal.titleStr == goal.titleStr
        }
        return filtered
    }

    func getGoalsWith(tag: Tag) -> [Goal] {
        let filtered = getGoals().filter { goal in
            goal.getTags().contains(where: { goalTag in
                goalTag == tag
            })
        }
        return filtered
    }

    // MARK: - Saved items

    func getSaved() -> [Saved] {
        guard let savedItems = Array(savedItems ?? []) as? [Saved] else {
            return []
        }

        return savedItems.sorted(by: { $0.getDate() > $1.getDate() })
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
        return saved.reduce(Double.zero) { $0 + $1.amount }
    }

    func getTimeSavedBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> TimeInterval {
        getAmountSavedBetween(startDate: startDate, endDate: endDate) / getWage().perSecond
    }

    func totalDollarsSaved() -> Double {
        getSaved().reduce(Double(0)) { $0 + $1.getAmount() }
    }

    func totalTimeSaved() -> Double {
        totalDollarsSaved() / getWage().perSecond
    }

    func getSavedItemsWith(tag: Tag) -> [Saved] {
        let filtered = getSaved().filter { saved in
            saved.getTags().contains(where: { savedTag in
                savedTag == tag
            })
        }
        return filtered
    }

    func getInstancesOf(savedItem: Saved) -> [Saved] {
        let filtered = getSaved().filter { saved in
            saved.getTitle() == savedItem.getTitle()
        }
        return filtered
    }
    
    
    // MARK: - Taxes
    
    func getStateTaxesPaid(from start: Date = .distantPast, to end: Date = .distantFuture) -> Double {
        getWage().stateTaxMultiplier * getTotalEarnedBetween(startDate: start, endDate: end)
    }
    
    func getFederalTaxesPaid(from start: Date = .distantPast, to end: Date = .distantFuture) -> Double {
        getWage().federalTaxMultiplier * getTotalEarnedBetween(startDate: start, endDate: end)
    }
    
    func getTotalTaxesPaid(from start: Date = .distantPast, to end: Date = .distantFuture) -> Double {
        getWage().totalTaxMultiplier * getTotalEarnedBetween(startDate: start, endDate: end)
    }

    // MARK: - Payoff Queue

    func getQueue() -> [PayoffItem] {
        var anyArr: [PayoffItem] = []

        anyArr += getExpenses()
        anyArr += getGoals()
        anyArr = anyArr.filter { $0.optionalQSlotNumber != nil }

        anyArr.sort { $0.optionalQSlotNumber! < $1.optionalQSlotNumber! }

        return anyArr
    }

    func getTempQueue() -> [PayoffItem] {
        var anyArr: [PayoffItem] = []

        anyArr += getExpenses()
        anyArr += getGoals()
        anyArr = anyArr.filter { $0.optionalTempQNum != nil }

        anyArr.sort { $0.optionalTempQNum! < $1.optionalTempQNum! }

        return anyArr
    }

    func getItemWith(queueSlot index: Int) -> PayoffItem? {
        getQueue().first(where: { $0.optionalQSlotNumber == Int16(index) })
    }

    func updateTempQueue() {
        let items = getQueue()
        items.forEach { $0.setOptionalTempQNum(newVal: $0.optionalQSlotNumber) }
    }

    // MARK: - Tags

    func getTags() -> [Tag] {
        guard let tags = Array(tags ?? []) as? [Tag] else {
            return []
        }

        return tags.sorted(by: { $0.getLastUsed() > $1.getLastUsed() })
    }

    // MARK: - Pay Periods

    func getPayPeriods() -> [PayPeriod] {
        guard let periods = Array(payPeriods ?? []) as? [PayPeriod] else {
            return []
        }

        return periods.filter { $0.payDay != nil }.sorted(by: { $0.payDay! > $1.payDay! })
    }

    func getPeriodFor(date: Date) -> PayPeriod? {
        getPayPeriods().first(where: { thisPeriod in
            guard let firstDate = thisPeriod.firstDate,
                  let lastDate = thisPeriod.payDay else { return false }
            let isAfterStart = date >= Date.beginningOfDay(firstDate)
            let isBeforeEnd = date <= Date.endOfDay(lastDate)
            return isAfterStart && isBeforeEnd
        })
    }

    func getCurrentPayPeriod() -> PayPeriod {
        // Get one if it already exists
        if let foundPeriod = getPayPeriods().first(where: { period in
            guard let firstDate = period.firstDate,
                  let lastDate = period.payDay
            else {
                return false
            }

            let beginning = Calendar.current.startOfDay(for: firstDate)
            let end = Date.endOfDay(lastDate)

            let nowIsAfterBeginning = Date.now >= beginning
            let nowIsBeforeEnd = Date.now <= end

            return nowIsAfterBeginning && nowIsBeforeEnd
        }) {
            return foundPeriod
        }

        // Make a current pay period if one doesn't already exist
        let settings = getPayPeriodSettings()
        let period: PayPeriod

        do {
            period = try PayPeriod(firstDate: .now,
                                   settings: settings,
                                   user: self,
                                   context: getContext())
        } catch {
            fatalError("Error creating default pay period")
        }
        return period
    }

    func getClosestPayPeriod(to givenDate: Date) -> PayPeriod? {
        var closestPayPeriod: PayPeriod?
        var closestInterval: TimeInterval = .greatestFiniteMagnitude

        for payPeriod in getPayPeriods() {
            let isWithinRange = givenDate > payPeriod.getFirstDate() && givenDate < payPeriod.getLastDate()
            let intervalToFirstDate = abs(givenDate.timeIntervalSince(payPeriod.getFirstDate()))
            let intervalToLastDate = abs(givenDate.timeIntervalSince(payPeriod.getLastDate()))

            if isWithinRange {
                // Given date falls within the range of this pay period
                return payPeriod
            } else {
                // Check if this pay period is closer than the previous closest
                if intervalToFirstDate < closestInterval {
                    closestPayPeriod = payPeriod
                    closestInterval = intervalToFirstDate
                }

                if intervalToLastDate < closestInterval {
                    closestPayPeriod = payPeriod
                    closestInterval = intervalToLastDate
                }
            }
        }

        return closestPayPeriod
    }

    func getPayPeriodSettings() -> PayPeriodSettings {
        if let payPeriodSettings {
            return payPeriodSettings
        }
        let settings: PayPeriodSettings
        do {
            settings = try PayPeriodSettings(cycleCadence: .biWeekly,
                                             autoGenerate: true,
                                             user: self,
                                             context: getContext())
        } catch {
            fatalError("Error creating default pay period settings \(error)")
        }
        return settings
    }

    // MARK: - TodayShift

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

    // MARK: - Unsorted

    func getPercentShiftExpenses() -> [PercentShiftExpense] {
        guard let percentExpenses = percentShiftExpenses?.allObjects as? [PercentShiftExpense] else {
            return []
        }

        return percentExpenses
    }

    // MARK: - Group shifts by week

    /**
     Groups the shifts by the week they fall in. This function categorizes each shift into a specific week and returns a dictionary where each key is a week in the format "Week of MMM d, yyyy - MMM d, yyyy" and the value is an array of shifts within that week. It also returns a sorted array of keys (weeks) for easy access.

     - Returns: A tuple containing two elements:
                - dict: A dictionary where the key is a string that represents a week in the "Week of MMM d, yyyy - MMM d, yyyy" format and the value is an array of shifts within that week.
                - sortedKeys: An array of strings that contains the sorted keys of the `dict` dictionary. The keys are sorted in the order they were added to the dictionary.

     - Complexity: O(n), where n is the number of shifts.

     - Note: The function uses the `getStartAndEndOfWeek` method of the `Date` object to determine the start and end dates of the week for each shift. If the `getStartAndEndOfWeek` method is not implemented in the `Date` object, this function will not work correctly.
     */
    func groupShiftsByWeek() -> (dict: [String: [Shift]], sortedKeys: [String]) {
        let shifts = getShifts()
        var groupedShifts: [String: [Shift]] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let keyDateFormatter = DateFormatter()
        keyDateFormatter.dateFormat = "MMM d, yyyy"

        var sortedKeys: [String] = []

        for shift in shifts {
            let startOfWeek = shift.start.getStartAndEndOfWeek().start
            let endOfWeek = shift.start.getStartAndEndOfWeek().end

            let weekKey = "Week of \(keyDateFormatter.string(from: startOfWeek)) - \(keyDateFormatter.string(from: endOfWeek))"

            if Set(sortedKeys).contains(weekKey) == false {
                sortedKeys.append(weekKey)
            }

            if groupedShifts[weekKey] == nil {
                groupedShifts[weekKey] = [shift]
            } else {
                groupedShifts[weekKey]?.append(shift)
            }
        }

        return (groupedShifts, sortedKeys)
    }

    // MARK: - Recurring Expenses

    func getRecurringExpenses() -> [Expense] {
        getExpenses().filter { $0.isRecurring }
    }

    func expensesThatNeedRecurring() -> [Expense] {
        getExpenses().filter { expense in
            guard expense.isRecurring,
                  let recurringDayNumber = expense.recurringDayNumber
            else { return false }
            let todayDayNumber = min(Calendar.current.component(.day, from: Date()), 30)
            return todayDayNumber == recurringDayNumber
        }
    }

    func createRecurredExpenses() throws {
        let expenses = expensesThatNeedRecurring()

        for expense in expenses {
            try Expense(title: expense.titleStr,
                        info: expense.info,
                        amount: expense.amount,
                        dueDate: expense.dueDate,
                        dateCreated: Date(),
                        isRecurring: true,
                        recurringDate: expense.recurringDate,
                        tagStrings: expense.getTags().map { $0.getTitle() },
                        user: self,
                        context: getContext())
        }
    }
}
