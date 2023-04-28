//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

extension User {
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
                let user = User(context: viewContext)
                user.username = "Testing User"
                user.email = "TestUser@ExampleForTest.com"

                let wage = Wage(context: viewContext)
                wage.amount = 20
                wage.user = user
                user.wage = wage
                
                try Expense.createExampleExpenses(user: user, context: viewContext)
                
                try Shift.createPreviewShifts(user: user)
                try Saved.generateDummySavedItems(user: user)

                try viewContext.save()
                return user
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
    
    
    func getSaved() -> [Saved] {
        guard let savedItems else { return [] }
        return Array(savedItems) as? [Saved] ?? []
    }
}
