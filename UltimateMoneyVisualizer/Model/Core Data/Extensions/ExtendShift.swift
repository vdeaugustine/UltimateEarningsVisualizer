//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import Vin

public extension Shift {
    @discardableResult convenience init(day: DayOfWeek, start: Date, end: Date, context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.startDate = start
        self.endDate = end
        self.dayOfWeek = day.rawValue

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
            let shift = try Shift(day: .init(date: day),
                                   start: Date.getThisTime(hour: 9, minute: 0, second: 0, from: day)!,
                                   end: Date.getThisTime(hour: 17, minute: 0, second: 0, from: day)!,
                                   context: context)
            
            // For each shift, create 20 random allocations to goals and expenses.
            for _ in 0 ..< 20 {
                // Check if there is any available amount left in the shift before creating allocations.
                if shift.totalAvailable > 0 {
                    // Randomly pick a goal that has a remaining amount to be paid off and create an allocation for it.
                    if let chosenGoal = goalsNotFinished.randomElement() {
                        let allocation = Allocation(amount: .random(in: 0 ... min(chosenGoal.amountRemainingToPayOff, shift.totalAvailable)), goal: chosenGoal, shift: shift, date: day, context: context)
                        shift.addToAllocations(allocation)
                        try context.save()
                    }
                    
                    // Randomly pick an expense that has a remaining amount to be paid off and create an allocation for it.
                    if let chosenExpense = expensesNotFinished.randomElement() {
                        let allocation = Allocation(amount: .random(in: 0 ... min(chosenExpense.amountRemainingToPayOff, shift.totalAvailable)), expense: chosenExpense, shift: shift, date: day, context: context)
                        shift.addToAllocations(allocation)
                        try context.save()
                    }
                }
            }
            try context.save()
        }
        try context.save()
    }


//    static func makeExampleShifts(user: User, context: NSManagedObjectContext) throws {
//        let startDate = Date.now
//        let goals = user.getGoals()
//        let expenses = user.getExpenses()
//
//        var expensesNotFinished: [Expense] {
//            expenses.filter { $0.amountRemainingToPayOff > 0 }
//        }
//        var goalsNotFinished: [Goal] {
//            goals.filter { $0.amountRemainingToPayOff > 0 }
//        }
//
//        for i in 0 ..< 20 {
//            let day = startDate.addDays(-Double(i))
//            let shift = try! Shift(day: .init(date: day),
//                                   start: Date.getThisTime(hour: 9, minute: 0, second: 0, from: day)!,
//                                   end: Date.getThisTime(hour: 17, minute: 0, second: 0, from: day)!,
//                                   context: context)
//            for _ in 0 ..< 20 {
//
//                if let chosenGoal = goalsNotFinished.randomElement() {
//                    let allocation = Allocation(amount: .random(in: 0 ... min(chosenGoal.amountRemainingToPayOff, shift.totalAvailable)), goal: chosenGoal, shift: shift, date: day, context: context)
//                    shift.addToAllocations(allocation)
//                    try! context.save()
//                }
//                if let chosenExpense = expensesNotFinished.randomElement() {
//                    let allocation = Allocation(amount: .random(in: 0 ... min(chosenExpense.amountRemainingToPayOff, shift.totalAvailable)), expense: chosenExpense, shift: shift, date: day, context: context)
//                    shift.addToAllocations(allocation)
//                    try! context.save()
//                }
//            }
//        }
//    }
}

extension Shift {
    var start: Date { startDate ?? .nineAM }
    var end: Date { endDate ?? .fivePM }

    var totalEarned: Double {
        guard let wage = User.main.wage else { return 0 }
        return wage.secondly * duration
    }

    var totalAllocated: Double {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return 0 }
        return allocations.reduce(Double(0)) { $0 + $1.amount }
    }

    var totalAvailable: Double {
        totalEarned - totalAllocated
    }

    static func totalDuration(for user: User) -> TimeInterval {
        let fetchRequest: NSFetchRequest<Shift> = Shift.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)

        do {
            let shifts = try user.managedObjectContext?.fetch(fetchRequest)
            let duration = shifts?.reduce(TimeInterval.zero) { $0 + $1.duration }
            return duration ?? TimeInterval.zero
        } catch {
            print("Error fetching shifts for user: \(error.localizedDescription)")
            return TimeInterval.zero
        }
    }

    var duration: TimeInterval {
        guard let endDate,
              let startDate else {
            return 0
        }
        return endDate.timeIntervalSince(startDate)
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
