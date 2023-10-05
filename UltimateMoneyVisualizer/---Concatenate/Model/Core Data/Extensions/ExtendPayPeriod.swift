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
                     settings: PayPeriodSettings,
                     user: User,
                     context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.dateSet = Date()
        self.firstDate = firstDate
        self.payDay = firstDate.addDays(settings.getCycleCadence().days)
        self.settings = settings
        self.cycleCadence = settings.cycleCadence
        self.user = user
        try context.save()
    }

    @discardableResult
    static func nonSavingInit(firstDate: Date,
                              settings: PayPeriodSettings,
                              user: User,
                              context: NSManagedObjectContext = PersistenceController.testing)
        -> PayPeriod {
        let period = PayPeriod(context: context)
        period.dateSet = Date()
        period.firstDate = firstDate
        period.payDay = firstDate.addDays(settings.getCycleCadence().days)
        period.settings = settings
        period.cycleCadence = settings.cycleCadence
        period.user = user
        return period
    }
}

public extension PayPeriod {
    var title: String {
        "Pay period for \(firstDate!.getFormattedDate(format: "MMM d")) - \(payDay!.getFormattedDate(format: .abbreviatedMonth))"
    }

    var dateRangeString: String {
        "\(firstDate!.getFormattedDate(format: "MMM d")) - \(payDay!.getFormattedDate(format: .abbreviatedMonth))"
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

    func thisPeriodCanContain(shift: Shift) -> Bool {
        guard let firstDate, let payDay else { return false }
        guard let shiftStart = shift.startDate,
              let shiftEnd = shift.endDate else {
            return false
        }

        return firstDate <= shiftStart && payDay >= shiftEnd
    }

    func thisPeriodContainsDates(_ date1: Date, and date2: Date) -> Bool {
        guard let firstDate, let payDay else { return false }
        return firstDate <= date1 && payDay >= date2
    }

    func totalTimeWorked() -> Double {
        getShifts().reduce(Double.zero) { $0 + $1.duration }
    }

    func totalEarned() -> Double {
        getShifts().reduce(Double.zero) { $0 + $1.totalEarned }
    }

    func totalEarnedAfterTaxes() -> Double {
        totalEarned() - taxesPaid()
    }

    func taxesPaid() -> Double {
        getShifts().reduce(Double.zero) { $0 + $1.taxesPaid }
    }

    func stateTaxesPaid() -> Double {
        getShifts().reduce(Double.zero) { $0 + $1.stateTaxesPaid }
    }

    func federalTaxesPaid() -> Double {
        getShifts().reduce(Double.zero) { $0 + $1.federalTaxesPaid }
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
                let firstDate = currentPayPeriod?.payDay?.addDays(1) ?? shift.start
                currentPayPeriod = try PayPeriod(firstDate: firstDate,
                                                 settings: payPeriodSettings,
                                                 user: user,
                                                 context: context)
                shift.payPeriod = currentPayPeriod
            }
        }
        try context.save()
    }

    static func createPayPeriodsFor(dateRange: Range<Date>, with settings: PayPeriodSettings, user: User, context: NSManagedObjectContext) throws {
        var startDate = Date.beginningOfDay(dateRange.lowerBound)
        while true {
            let payPeriod = try PayPeriod(firstDate: startDate, settings: settings, user: user, context: context)
            if let payDay = payPeriod.payDay, payDay > Date.endOfDay(dateRange.upperBound) {
                break
            }
            startDate = Calendar.current.startOfDay(for: (payPeriod.payDay?.addDays(1)) ?? startDate) 
        }
    }
}
