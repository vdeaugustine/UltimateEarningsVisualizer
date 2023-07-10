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

public extension Shift {
    @discardableResult convenience init(day: DayOfWeek,
                                        start: Date,
                                        end: Date,
                                        fixedExpense: PercentShiftExpense? = nil,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
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

        try context.save()
    }

    // This function creates example shifts for a user with random allocations to goals and expenses.
    static func makeExampleShifts(user: User, context: NSManagedObjectContext) throws {
        let startDate = Date.now
        let goals = user.getGoals()
        let expenses = user.getExpenses()

        // Get the list of expenses that still have remaining amounts to be paid off.
        var expensesNotFinished: [Expense] {
            expenses.filter { $0.amountRemainingToPayOff > 0 }
        }

        // Get the list of goals that still have remaining amounts to be paid off.
        var goalsNotFinished: [Goal] {
            goals.filter { $0.amountRemainingToPayOff > 0 }
        }

        // Create 20 shifts, starting from today and going back in time, one shift per day.
        for i in 0 ..< 20 {
            let day = startDate.addDays(-Double(i))
            let shiftStart = Date.getThisTime(hour: 7, minute: 0, second: 0, from: day)!
            let shiftEnd = Date.getThisTime(hour: 15, minute: 30, second: 0, from: day)!

            // Create 3 TimeBlocks (but only for the first one)
            // TODO: Add for other ones

            let shift = try Shift(day: .init(date: day),
                                  start: shiftStart,
                                  end: shiftEnd,
                                  user: user,
                                  context: context)

            // first block (9am to 11am)
            try TimeBlock(title: "Breakfast",
                          start: Date.getThisTime(hour: 7, minute: 15, from: shiftStart)!,
                          end: Date.getThisTime(hour: 8, minute: 0, from: shiftStart)!,
                          colorHex: Color.overcastColors.randomElement()!,
                          shift: shift,
                          user: user,
                          context: context)

            // second block (11:15am to 12pm)
            try TimeBlock(title: "Talk on Phone",
                          start: Date.getThisTime(hour: 8, minute: 0, from: shiftStart)!,
                          end: Date.getThisTime(hour: 9, minute: 55, from: shiftStart)!,
                          colorHex: Color.overcastColors.randomElement()!,
                          shift: shift,
                          user: user,
                          context: context)

            // third block (12:30 to 3pm)
            try TimeBlock(title: "Worked",
                          start: Date.getThisTime(hour: 10, minute: 30, from: shiftStart)!,
                          end: Date.getThisTime(hour: 11, minute: 30, from: shiftStart)!,
                          colorHex: Color.overcastColors.randomElement()!,
                          shift: shift,
                          user: user,
                          context: context)

            try TimeBlock(title: "Balled out",
                          start: Date.getThisTime(hour: 11, minute: 35, from: shiftStart)!,
                          end: Date.getThisTime(hour: 13, minute: 30, from: shiftStart)!,
                          colorHex: Color.overcastColors.randomElement()!,
                          shift: shift,
                          user: user,
                          context: context)

            // For each shift, create 20 random allocations to goals and expenses.
            for _ in 0 ..< 20 {
                // Check if there is any available amount left in the shift before creating allocations.
                if shift.totalAvailable > 0 {
                    // Randomly pick a goal that has a remaining amount to be paid off and create an allocation for it.
                    if let chosenGoal = goalsNotFinished.randomElement() {
                        let allocatableAmount = min(chosenGoal.amountRemainingToPayOff,
                                                    shift.totalAvailable)
                        if allocatableAmount >= 0.01 {
                            let allocation = try! Allocation(amount: .random(in: 0.01 ... allocatableAmount),
                                                             goal: chosenGoal,
                                                             shift: shift,
                                                             date: day,
                                                             context: context)
                            shift.addToAllocations(allocation)
                            try context.save()
                        }
                    }

                    // Randomly pick an expense that has a remaining amount to be paid off and create an allocation for it.
                    if let chosenExpense = expensesNotFinished.randomElement() {
                        let allocatableAmount = min(chosenExpense.amountRemainingToPayOff,
                                                    shift.totalAvailable)
                        if allocatableAmount >= 0.01 {
                            let allocation = try! Allocation(amount: .random(in: 0.01 ... allocatableAmount),
                                                             expense: chosenExpense,
                                                             shift: shift,
                                                             date: day,
                                                             context: context)
                            shift.addToAllocations(allocation)
                            try context.save()
                        }
                    }
                }
            }

//            shift.user = user
//            user.addToShifts(shift)
            try context.save()
        }
        try context.save()
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
        
        return allocations.filter({ $0.goal != nil }).reduce(Double(0)) { $0 + $1.amount }
    }
    var allocatedToExpenses: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }
        
        return allocations.filter({ $0.expense != nil }).reduce(Double(0)) { $0 + $1.amount }
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
