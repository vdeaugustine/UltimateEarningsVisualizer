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

func doDateRangesOverlap(startTime1: Date, endTime1: Date, startTime2: Date, endTime2: Date) -> Bool {
    let sortedDates1 = [startTime1, endTime1].sorted()
    let sortedDates2 = [startTime2, endTime2].sorted()

    let latestStartTime = max(sortedDates1[0], sortedDates2[0])
    let earliestEndTime = min(sortedDates1[1], sortedDates2[1])

    return latestStartTime < earliestEndTime
}

public extension Shift {
    @discardableResult convenience init(day: DayOfWeek,
                                        start: Date,
                                        end: Date,
                                        payPeriod: PayPeriod? = nil,
                                        fixedExpense: PercentShiftExpense? = nil,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        let conflictingShifts = user.getShifts().filter { existingShift in

            doDateRangesOverlap(startTime1: start, endTime1: end, startTime2: existingShift.start, endTime2: existingShift.end)
        }

        if !conflictingShifts.isEmpty {
            throw NSError(domain: "Shift Conflict", code: 0, userInfo: [NSLocalizedDescriptionKey: "There are existing shifts with the same start or end time within the same hour."])
        }

        self.init(context: context)
        self.startDate = start
        self.endDate = end
        self.dayOfWeek = day.rawValue
        self.user = user

        if let fixedExpense = fixedExpense {
            addToPercentShiftExpenses(fixedExpense)
        }

        if let fixedExpenses = user.percentShiftExpenses?.allObjects as? [PercentShiftExpense] {
            for fixedExpense in fixedExpenses {
                addToPercentShiftExpenses(fixedExpense)
            }
        }
//
//        // Giving it a pay period
//        let existingPayPeriods = user.getPayPeriods().sorted(by: { $0.getLastDate() > $1.getLastDate() })
//
//        // Check if one exists that this shift falls into
//        if let payPeriodThisShiftFallsInto = existingPayPeriods.first(where: { period in
//            guard let firstDate = period.firstDate else {
//                return false
//            }
//            let shiftStartIsAfterPeriodStart = firstDate <= start
//            print("first date for period is: \(firstDate.getFormattedDate(format: .abbreviatedMonthAndMinimalTime))")
//            print("start date for shift is:", start.getFormattedDate(format: .abbreviatedMonthAndMinimalTime))
//            let shiftEndIsBeforePeriodEnd = end <= period.getLastDate()
//            return shiftStartIsAfterPeriodStart && shiftEndIsBeforePeriodEnd
//        }) {
//            self.payPeriod = payPeriodThisShiftFallsInto
//        } else {
//            let currentPayPeriod = existingPayPeriods.last
//
//            let firstDate = currentPayPeriod?.payDay?.addDays(1) ?? Date.beginningOfDay(start)
//            let newPayPeriod = try PayPeriod(firstDate: firstDate,
//                                             settings: user.payPeriodSettings ?? PayPeriodSettings(cycleCadence: .biWeekly,
//                                                                                                   autoGenerate: true,
//                                                                                                   user: user,
//                                                                                                   context: context),
//                                             user: user,
//                                             context: context)
//        }

        try context.save()
    }

    /// Creates a new shift given a ``TodayShift``
    convenience init(fromTodayShift todayShift: TodayShift, payPeriod: PayPeriod? = nil, context: NSManagedObjectContext) throws {
        self.init(context: context)

        self.startDate = todayShift.startTime
        self.endDate = todayShift.endTime
        self.dayOfWeek = DayOfWeek(date: todayShift.startTime ?? .now).rawValue

        // Set any other properties from TodayShift

        self.user = todayShift.user

        guard let user else {
            throw NSError(domain: "Was unable to get the user. This should not happen", code: 99)
        }
        // Giving it a pay period
        let existingPayPeriods = user.getPayPeriods().sorted(by: { $0.getLastDate() > $1.getLastDate() })

        // Check if one exists that this shift falls into
        if let payPeriodThisShiftFallsInto = existingPayPeriods.first(where: { period in
            guard let firstDate = period.firstDate else { return false }
            let shiftStartIsAfterPeriodStart = firstDate <= start
            let shiftEndIsBeforePeriodEnd = end <= period.getLastDate()
            return shiftStartIsAfterPeriodStart && shiftEndIsBeforePeriodEnd
        }) {
            self.payPeriod = payPeriodThisShiftFallsInto
        } else {
            let currentPayPeriod = existingPayPeriods.first
            let firstDate = currentPayPeriod?.payDay?.addDays(1) ?? start
            let newPayPeriod = try PayPeriod(firstDate: firstDate,
                                             settings: user.payPeriodSettings ?? PayPeriodSettings(cycleCadence: .biWeekly,
                                                                                                   autoGenerate: true,
                                                                                                   user: user,
                                                                                                   context: context),
                                             user: user,
                                             context: context)
        }

        try context.save()
    }

    // This function creates example shifts for a user with random allocations to goals and expenses.
//    static func makeExampleShifts(user: User, context: NSManagedObjectContext) throws {
//        let startDate = Date.now
//        let goals = user.getGoals()
//        let expenses = user.getExpenses()
//
//        // Get the list of expenses that still have remaining amounts to be paid off.
//        var expensesNotFinished: [Expense] {
//            expenses.filter { $0.amountRemainingToPayOff > 0 }
//        }
//
//        // Get the list of goals that still have remaining amounts to be paid off.
//        var goalsNotFinished: [Goal] {
//            goals.filter { $0.amountRemainingToPayOff > 0 }
//        }
//
//        let numberOfShifts = 20
//
//        let firstDate = Calendar.current.date(byAdding: .day, value: -numberOfShifts, to: .now)!
//        let settings = try PayPeriodSettings(cycleCadence: .biWeekly, autoGenerate: true, user: user, context: context)
//
//        try PayPeriod.createPayPeriodsFor(dateRange: firstDate ..< .now.addDays(2), with: settings, user: user, context: context)
//
//        // Create 20 shifts, starting from today and going back in time, one shift per day.
//        for i in 0 ..< numberOfShifts {
//            let day = startDate.addDays(-Double(i))
//            let shiftStart = Date.getThisTime(hour: 7, minute: 0, second: 0, from: day)!
//            let shiftEnd = Date.getThisTime(hour: 15, minute: 30, second: 0, from: day)!
//
//            // Create 3 TimeBlocks (but only for the first one)
//            // TODO: Add for other ones
//
//            let shift = try Shift(day: .init(date: day),
//                                  start: shiftStart,
//                                  end: shiftEnd,
//                                  user: user,
//                                  context: context)
//
//            if let period = user.getPayPeriods().first(where: { $0.thisPeriodCanContain(shift: shift)}) {
//                shift.payPeriod = period
//            } else {
//                for period in user.getPayPeriods() {
//                    print("===")
//                    print("Period start: \(period.getFirstDate().getFormattedDate(format: .abbreviatedMonthAndMinimalTime))")
//                    print("Period end: \(period.getLastDate().getFormattedDate(format: .abbreviatedMonthAndMinimalTime))")
//                    print("===")
//                }
//                fatalError()
//            }
//
//            // first block (9am to 11am)
//            try TimeBlock(title: "Breakfast",
//                          start: Date.getThisTime(hour: 7, minute: 15, from: shiftStart)!,
//                          end: Date.getThisTime(hour: 8, minute: 0, from: shiftStart)!,
//                          colorHex: Color.overcastColors.randomElement()!,
//                          shift: shift,
//                          user: user,
//                          context: context)
//
//            // second block (11:15am to 12pm)
//            try TimeBlock(title: "Talk on Phone",
//                          start: Date.getThisTime(hour: 8, minute: 0, from: shiftStart)!,
//                          end: Date.getThisTime(hour: 9, minute: 55, from: shiftStart)!,
//                          colorHex: Color.overcastColors.randomElement()!,
//                          shift: shift,
//                          user: user,
//                          context: context)
//
//            // third block (12:30 to 3pm)
//            try TimeBlock(title: "Worked",
//                          start: Date.getThisTime(hour: 10, minute: 30, from: shiftStart)!,
//                          end: Date.getThisTime(hour: 11, minute: 30, from: shiftStart)!,
//                          colorHex: Color.overcastColors.randomElement()!,
//                          shift: shift,
//                          user: user,
//                          context: context)
//
//            try TimeBlock(title: "Played Basketball",
//                          start: Date.getThisTime(hour: 11, minute: 35, from: shiftStart)!,
//                          end: Date.getThisTime(hour: 13, minute: 30, from: shiftStart)!,
//                          colorHex: Color.overcastColors.randomElement()!,
//                          shift: shift,
//                          user: user,
//                          context: context)
//
//            // MARK: - Allocations here
//
//            // For each shift, create x random allocations to goals and expenses.
//            let x = 3
//            for _ in 0 ..< x {
//                // Check if there is any available amount left in the shift before creating allocations.
//                if shift.totalAvailable > 0 {
//                    // Randomly pick a goal that has a remaining amount to be paid off and create an allocation for it.
//                    if let chosenGoal = goalsNotFinished.randomElement() {
//                        let allocatableAmount = min(chosenGoal.amountRemainingToPayOff,
//                                                    shift.totalAvailable)
//                        if allocatableAmount >= 0.01 {
//                            let allocation = try! Allocation(amount: .random(in: 0.01 ... allocatableAmount),
//                                                             goal: chosenGoal,
//                                                             shift: shift,
//                                                             date: day,
//                                                             context: context)
//                            shift.addToAllocations(allocation)
//                            try context.save()
//                        }
//                    }
//
//                    // Randomly pick an expense that has a remaining amount to be paid off and create an allocation for it.
//                    if let chosenExpense = expensesNotFinished.randomElement() {
//                        let allocatableAmount = min(chosenExpense.amountRemainingToPayOff,
//                                                    shift.totalAvailable)
//                        if allocatableAmount >= 0.01 {
//                            let allocation = try! Allocation(amount: .random(in: 0.01 ... allocatableAmount),
//                                                             expense: chosenExpense,
//                                                             shift: shift,
//                                                             date: day,
//                                                             context: context)
//                            shift.addToAllocations(allocation)
//                            try context.save()
//                        }
//                    }
//                }
//            }
//
//            try context.save()
//        }
//        try context.save()
//    }

    static func makeExampleShifts(user: User, context: NSManagedObjectContext) throws {
        let viewContext = context

        // Make the 50 before today
        let previous50Weekdays = Date.getPreviousWeekdays(count: 50)
        let next50Weekdays = Date.getNextWeekdays(count: 50)

        let allWeekdays = previous50Weekdays + next50Weekdays
        let sortedWeekdays = allWeekdays.sorted()

        var currentPayPeriod: PayPeriod?

        for weekday in sortedWeekdays {
            let shift = Shift(context: viewContext)
            shift.dayOfWeek = DayOfWeek(date: weekday).rawValue
            shift.startDate = Date.getThisTime(hour: 9, minute: 0, second: 0, from: weekday)
            shift.endDate = Date.getThisTime(hour: 17, minute: 0, second: 0, from: weekday)
            shift.user = user

            if let payPeriod = currentPayPeriod,
               let shiftStart = shift.startDate,
               let periodFirstDate = payPeriod.firstDate,
               let periodPayDay = payPeriod.payDay,
               shiftStart >= periodFirstDate,
               shiftStart <= periodPayDay {
                shift.payPeriod = payPeriod
            } else {
                let firstDate = currentPayPeriod?.payDay?.addDays(1) ?? shift.start
                currentPayPeriod = try PayPeriod(firstDate: firstDate,
                                                 settings: user.payPeriodSettings!,
                                                 user: user,
                                                 context: context)
                shift.payPeriod = currentPayPeriod
            }

            try viewContext.save()
        }
    }
}

extension Shift {
    var title: String {
        "Shift for \(start.getFormattedDate(format: .minimalTime)) - \(end.getFormattedDate(format: .minimalTime)) \(end.getFormattedDate(format: .slashDate))"
    }

    var start: Date { startDate ?? .nineAM }
    var end: Date { endDate ?? .fivePM }

    var totalEarned: Double {
        guard let wage = User.main.wage else { return 0 }
        if wage.isSalary {
            return wage.perDay
        } else {
            return wage.perSecond * duration
        }
    }

    var totalAllocated: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var allocatedToGoals: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }

        return allocations.filter { $0.goal != nil }.reduce(Double(0)) { $0 + $1.amount }
    }

    var allocatedToExpenses: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }

        return allocations.filter { $0.expense != nil }.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalAvailable: Double {
        let earned = User.main.getWage().includeTaxes ? totalEarnedAfterTaxes : totalEarned
        return earned - totalAllocated
    }

    var totalEarnedAfterTaxes: Double {
        totalEarned - taxesPaid
    }

    var duration: TimeInterval {
        guard let endDate,
              let startDate else {
            return 0
        }
        return endDate.timeIntervalSince(startDate)
    }

    var taxesPaid: Double {
        guard let includesTaxes = user?.wage?.includeTaxes,
              includesTaxes
        else { return 0 }
        return stateTaxesPaid + federalTaxesPaid
    }

    var stateTaxesPaid: Double {
        (user?.wage?.stateTaxMultiplier ?? 0) * totalEarned
    }

    var federalTaxesPaid: Double {
        (user?.wage?.federalTaxMultiplier ?? 0) * totalEarned
    }

    func getAllocations() -> [Allocation] {
        guard let allocations = allocations?.allObjects as? [Allocation] else {
            return []
        }

        return allocations
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

    func getPercentShiftExpenses() -> [PercentShiftExpense] {
        guard let percentExpenses = percentShiftExpenses?.allObjects as? [PercentShiftExpense] else {
            return []
        }

        return percentExpenses
    }

    func getPayoffItemsAllocatedTo() -> [PayoffItem] {
        let expenses = expensesAllocatedTo()
        let goals = goalsAllocatedTo()
        let combined: [PayoffItem] = goals + expenses

        return combined.sorted(by: { self.amountAllocated(for: $0) > self.amountAllocated(for: $1) })
    }

    func getTimeBlocks() -> [TimeBlock] {
        guard let blocks = timeBlocks?.allObjects as? [TimeBlock] else {
            return []
        }

        return blocks.sorted(by: { ($0.startTime ?? .distantFuture) < ($1.endTime ?? .distantFuture) })
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
}

// MARK: - Just for previews

extension Shift {
    static func createPreviewShifts(user: User) throws {
        let viewContext = PersistenceController.context

        // Make the 50 before today
        let previous50Weekdays = Date.getPreviousWeekdays(count: 50)
        let next50Weekdays = Date.getNextWeekdays(count: 50)

        for weekday in previous50Weekdays {
            let shift = Shift(context: viewContext)
            shift.dayOfWeek = DayOfWeek(date: weekday).rawValue
            shift.startDate = Date.getThisTime(hour: 9, minute: 0, second: 0, from: weekday)
            shift.endDate = Date.getThisTime(hour: 17, minute: 0, second: 0, from: weekday)
            shift.user = user
            try viewContext.save()
        }

        for weekday in next50Weekdays {
            let shift = Shift(context: viewContext)
            shift.dayOfWeek = DayOfWeek(date: weekday).rawValue
            shift.startDate = Date.getThisTime(hour: 9, minute: 0, second: 0, from: weekday)
            shift.endDate = Date.getThisTime(hour: 17, minute: 0, second: 0, from: weekday)
            shift.user = user
            try viewContext.save()
        }
    }
}

// MARK: - Shift + ShiftProtocol

extension Shift: ShiftProtocol {
    func getStart() -> Date {
        start
    }

    func getEnd() -> Date {
        end
    }
}
