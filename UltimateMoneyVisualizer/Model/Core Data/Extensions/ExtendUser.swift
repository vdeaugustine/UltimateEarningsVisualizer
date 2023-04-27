//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

extension User {
//    static func createTestUser() -> User {
//        #if DEBUG
//            let viewContext = PersistenceController.preview.container.viewContext
//        #else
//            let viewContext = PersistenceController.shared.container.viewContext
//        #endif
//
//        let user = User(context: viewContext)
//        user.username = "Testing User"
//        user.email = "TestUser@ExampleForTest.com"
//        let wage = Wage(context: viewContext)
//        wage.amount = 62.50
//        wage.user = user
//        user.wage = wage
//
//
//
//
//    }

    static var main: User {
        let viewContext = PersistenceController.context

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1

        do {
            let results = try viewContext.fetch(request)
            if let user = results.first {
                return user
            } else {
                let user = User(context: viewContext)
                user.username = "Testing User"
                user.email = "TestUser@ExampleForTest.com"

                let wage = Wage(context: viewContext)
                wage.amount = 20
                wage.user = user
                user.wage = wage
                
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
}
