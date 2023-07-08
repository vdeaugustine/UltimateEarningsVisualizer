//
//  ExtendPayPeriod.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import CoreData
import Foundation
import Vin

public extension PayPeriod {
    @discardableResult
    convenience init(firstDate: Date,
                     payDay: Date,
                     settings: PayPeriodSettings,
                     user: User,
                     context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.dateSet = Date()
        self.firstDate = firstDate
        self.payDay = payDay
        self.settings = settings
        self.cycleCadence = settings.cycleCadence
        self.user = user
        try context.save()
    }
}

public extension PayPeriod {
    var title: String {
        "Pay period for \(firstDate!.getFormattedDate(format: "MMM d")) - \(payDay!.getFormattedDate(format: .abreviatedMonth))"
    }

    func getFirstDate() -> Date {
        firstDate ?? .distantPast
    }

    func getLastDate() -> Date {
        payDay ?? .distantFuture
    }

    func getCadence() -> PayCycle {
        guard let cycleCadence,
              let cycle = PayCycle(rawValue: cycleCadence)
        else {
            return .biWeekly
        }
        return cycle
    }

    func setCadence(new cycle: PayCycle) throws {
        cycleCadence = cycle.rawValue
        try user?.getContext().save()
    }

    /// Ordered from most recent to oldest
    func getShifts() -> [Shift] {
        guard let shifts = Array(shifts ?? []) as? [Shift] else {
            return []
        }
        return shifts.sorted(by: { $0.start > $1.start })
    }

    // Function to assign shifts to pay periods
    static func assignShiftsToPayPeriods() throws {
        let user = User.main
        guard let context = user.managedObjectContext,
              let payPeriodSettings = user.payPeriodSettings

        else { return }
        let shifts = user.getShifts().reversed().filter { $0.payPeriod == nil }

        var currentPayPeriod: PayPeriod?
        for shift in shifts {
            // If the shift falls within the current pay period, assign it
            if let payPeriod = currentPayPeriod,
               let shiftStart = shift.startDate,
               let periodFirstDate = payPeriod.firstDate,
               let periodPayDay = payPeriod.payDay,
               shiftStart >= periodFirstDate,
               shiftStart <= periodPayDay {
                shift.payPeriod = payPeriod
            } else {
                // Otherwise, create a new pay period starting the day after the last one ended

                let firstDate = (currentPayPeriod?.payDay ?? shift.start).addDays(1)
                currentPayPeriod = try PayPeriod(firstDate: firstDate,
                              payDay: firstDate.addDays(payPeriodSettings.getCycleCadence().days),
                              settings: payPeriodSettings,
                              user: user,
                              context: context)
                shift.payPeriod = currentPayPeriod
            }
        }
        try context.save()
    }

//    static func makePayPeriodsForExistingShifts() throws {
//        /// Shifts ordered from oldest to newest
//
//        let user = User.main
//        let shifts = user.getShifts().reversed()
//        guard let firstShift = shifts.first,
//              let lastShift = shifts.last,
//              let settings = user.payPeriodSettings
//        else { return }
//        let firstDateOfAllPeriods = firstShift.start
//        var workingDate = Date.beginningOfDay(firstDateOfAllPeriods)
//        // Starting from the first date, work your way up making all the periods you need
//        while workingDate < lastShift.end {
//            let payDate = Date.endOfDay(workingDate.addDays(settings.getCycleCadence().days))
//            // Create a pay period
//            let thisPeriod = try PayPeriod(firstDate: workingDate,
//                                           payDay: payDate,
//                                           settings: settings,
//                                           user: user,
//                                           context: user.getContext())
//            workingDate = payDate.advanced(by: 1)
//        }
//    }
}
