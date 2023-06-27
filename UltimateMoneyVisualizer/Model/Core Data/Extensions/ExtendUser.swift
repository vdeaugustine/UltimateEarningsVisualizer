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
                                        viewContext: NSManagedObjectContext = PersistenceController.testing) throws {
        self.init(context: viewContext)
        self.username = "Testing User"
        self.email = "TestUser@ExampleForTest.com"

        let wage = Wage(context: viewContext)
        wage.amount = 35
        wage.user = self
        self.wage = wage
//        let four01K = try PercentShiftExpense(title: "401K", percent: 0.06, user: self, context: viewContext)

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
//                try TodayShift.makeExampleTodayShift(user: self, context: viewContext)

                RegularSchedule([.monday, .tuesday, .wednesday, .thursday, .friday], user: self, context: viewContext)

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

    static func getTestingUserWithExamples() throws -> User {
        try User(exampleItem: true)
    }

    static var main: User {
        let viewContext = PersistenceController.context

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1

        do {
            let results = try viewContext.fetch(request)
            if results.count > 1 {
                fatalError("MORE THAN ONE USER")
            }

            // Get the user from the results
            if let user = results.first {
                // If the user has a TodayShift
                if let today = user.todayShift,
                   let endOfToday = today.endTime {
                    // If the shift is from a previous day (so it is expired)
                    if endOfToday < Date.beginningOfDay() {
                        // We want to set todayShift to nil and not return that user
                        user.todayShift = nil
                    } else {
                        // Nothing else needs to be done so the user can be returned
                        return user
                    }
                }

                // There is no valid todayShift *but* has a shift today
                if let shiftThatIsToday = user.getTodayShift() {
                    // Create a todayShift
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

    func getContext() -> NSManagedObjectContext {
        managedObjectContext ?? PersistenceController.context
    }

    /// Gives you the amount of money the user has netted between the two dates. So it in
    func totalNetMoneyBetween(_ startDate: Date, _ endDate: Date) -> Double {
        // Total net money should be this formula
        // Earned + Saved - (AllocatedUpToThisDay)

        let earned = getTotalEarnedBetween(startDate: startDate, endDate: endDate)
        let amountSaved = getAmountSavedBetween(startDate: startDate, endDate: endDate)
        let expenses = getExpensesSpentBetween(startDate: startDate, endDate: endDate)
        let goals = getGoalsSpentBetween(startDate: startDate, endDate: endDate)

        return (earned + amountSaved) - (expenses + goals)
    }

    func totalEarned() -> Double {
        guard let wage else { return 0 }
        let totalDuration = totalTimeWorked()
        let hourlyRate = wage.amount
        let secondlyRate = hourlyRate / 60 / 60
        return totalDuration * secondlyRate
    }

    

    /// Gives a list of shifts falling in between the two given dates that have already been saved.
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
            guard let date = expense.dueDate else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredExpenses
    }

    func getGoalsBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [Goal] {
        let filteredGoals = getGoals().filter { goal in
            guard let date = goal.dateCreated else { return false }
            return (date >= startDate && date <= endDate)
        }
        return filteredGoals
    }

    /**
     - Parameters: Default - distant past and distant future. So calling this with no parameter will give all saved items
     - Returns: all the saved items that have a `date` that is between the two parameters
     */
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

    /// The amount of money spent by expenses in between the two given dates.
    /// Parameters default to include all dates
    func getExpensesSpentBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let expenses = getExpensesBetween(startDate: startDate, endDate: endDate)
        return expenses.reduce(Double.zero) { $0 + $1.amount }
    }

    /// The amount of money spent by goals in between the two given dates.
    /// Parameters default to include all dates
    func getGoalsSpentBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> Double {
        let goals = getGoalsBetween(startDate: startDate, endDate: endDate)
        return goals.reduce(Double.zero) { $0 + $1.amount }
    }

    func getTimeBlocksBetween(startDate: Date = .distantPast, endDate: Date = .distantFuture) -> [TimeBlock] {
        let shifts = getShiftsBetween(startDate: startDate, endDate: endDate)

        return shifts.flatMap { $0.getTimeBlocks() }
    }

    func getPercentShiftExpenses() -> [PercentShiftExpense] {
        guard let percentExpenses = percentShiftExpenses?.allObjects as? [PercentShiftExpense] else {
            return []
        }

        return percentExpenses
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

        return array.sorted(by: { $0.start > $1.start })
    }

    /// Retrieves the shift happening today from a collection of shifts.
    /// - Returns: The shift object that matches the current day, or nil if no shift is found or an error occurs.
    func getTodayShift() -> Shift? {
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

    var hasShiftToday: Bool { getTodayShift() != nil }

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

    func updateTempQueue() {
        let items = getQueue()
        items.forEach { $0.setOptionalTempQNum(newVal: $0.optionalQSlotNumber) }
    }

    func getItemWith(queueSlot index: Int) -> PayoffItem? {
        getQueue().first(where: { $0.optionalQSlotNumber == Int16(index) })

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
        guard let savedItems = Array(savedItems ?? []) as? [Saved] else {
            return []
        }

        return savedItems.sorted(by: { $0.getDate() > $1.getDate() })
    }

    func getTags() -> [Tag] {
        guard let tags = Array(tags ?? []) as? [Tag] else {
            return []
        }

        return tags.sorted(by: { $0.getLastUsed() > $1.getLastUsed() })
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

    func getPayCycle() -> PayCycle? {
        guard let cycle = payPeriod?.payCycle else { return nil }
        return PayCycle(rawValue: cycle)
    }

    func setPayCycle(_ payCycle: PayCycle) {
        payPeriod?.payCycle = payCycle.rawValue
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

    func getItemsWith(tag: Tag) -> [Any] {
        []
    }

    func getGoalsWith(tag: Tag) -> [Goal] {
        let filtered = getGoals().filter { goal in
            goal.getTags().contains(where: { goalTag in

                goalTag == tag

            })
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

    func getInstancesOf(expense: Expense) -> [Expense] {
        let filtered = getExpenses().filter { thisExpense in
            thisExpense.titleStr == expense.titleStr
        }
        return filtered
    }

    func getInstancesOf(goal: Goal) -> [Goal] {
        let filtered = getGoals().filter { thisGoal in
            thisGoal.titleStr == goal.titleStr
        }
        return filtered
    }
}
