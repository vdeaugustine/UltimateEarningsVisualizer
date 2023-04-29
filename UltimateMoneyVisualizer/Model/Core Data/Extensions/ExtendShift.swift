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
        return allocations.reduce(Double(0), {$0 + $1.amount})
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
