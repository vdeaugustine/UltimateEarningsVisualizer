//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation

public extension Wage {
    @discardableResult convenience init(amount: Double,
                                        isSalary: Bool,
                                        user: User,
                                        includeTaxes: Bool,
                                        stateTax: Double?,
                                        federalTax: Double?,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.amount = amount
        self.isSalary = isSalary
        self.user = user
        self.includeTaxes = includeTaxes
        if let stateTax {
            self.stateTaxPercentage = stateTax
        }
        if let federalTax {
            self.federalTaxPercentage = federalTax
        }

        try context.save()
    }

    var stateTaxMultiplier: Double {
        stateTaxPercentage / 100
    }

    var totalTaxMultiplier: Double {
        stateTaxMultiplier + federalTaxMultiplier
    }

    var federalTaxMultiplier: Double {
        federalTaxPercentage / 100
    }

    var hourly: Double {
        amount
    }

    var secondly: Double {
        amount / 60 / 60
    }

    var perSecond: Double {
        perMinute / 60
    }

    var perMinute: Double {
        amount / 60
    }

    var perDay: Double {
        amount * hoursPerDay
    }

    var perWeek: Double {
        perDay * daysPerWeek
    }

    var perMonth: Double {
        perWeek * 4
    }

    var perYear: Double {
        perWeek * weeksPerYear
    }

    enum TimePeriod {
        case hourly(wage: Wage)
        case secondly(wage: Wage)
        case perSecond(wage: Wage)
        case perMinute(wage: Wage)
        case perDay(wage: Wage)
        case perWeek(wage: Wage)
        case perMonth(wage: Wage)
        case perYear(wage: Wage)

        var description: String {
            switch self {
                case .hourly:
                    return "Hourly"
                case .secondly:
                    return "Per Second"
                case .perSecond:
                    return "Per Second"
                case .perMinute:
                    return "Per Minute"
                case .perDay:
                    return "Per Day"
                case .perWeek:
                    return "Per Week"
                case .perMonth:
                    return "Per Month"
                case .perYear:
                    return "Per Year"
            }
        }

        var stringValue: String {
            switch self {
                case .hourly:
                    return "hour"
                case .secondly:
                    return "second"
                case .perSecond:
                    return "second"
                case .perMinute:
                    return "minute"
                case .perDay:
                    return "day"
                case .perWeek:
                    return "week"
                case .perMonth:
                    return "month"
                case .perYear:
                    return "year"
            }
        }

        func calculateAmount(for amount: Double) -> Double {
            switch self {
                case let .hourly(wage):
                    return amount * wage.hourly
                case let .secondly(wage):
                    return amount * wage.secondly
                case let .perSecond(wage):
                    return amount * wage.perSecond
                case let .perMinute(wage):
                    return amount * wage.perMinute
                case let .perDay(wage):
                    return amount * wage.perDay
                case let .perWeek(wage):
                    return amount * wage.perWeek
                case let .perMonth(wage):
                    return amount * wage.perMonth
                case let .perYear(wage):
                    return amount * wage.perYear
            }
        }
    }
}
