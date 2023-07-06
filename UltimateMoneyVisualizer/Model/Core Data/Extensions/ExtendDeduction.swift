//
//  ExtendDeductions.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/26/23.
//

import CoreData
import Foundation

public extension Deduction {
    @discardableResult convenience init(title: String,
                                        amount: Double,
                                        type: DeductionType,
                                        amountType: AmountType,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        self.amount = amount
        self.type = type.rawValue
        self.amountType = amountType.rawValue
        self.user = user

        try context.save()
    }

    enum AmountType: String, CaseIterable, Identifiable, Hashable {
        case percentage = "Percentage of Earnings"
        case fixedAmount = "Fixed Amount"

        public var id: Self { self }
    }

    enum DeductionType: String, CaseIterable, Identifiable, Hashable {
        case preTaxDeductions = "Pre Tax Deductions"
        case taxes = "Taxes"
        case afterTaxDeductions = "After Tax Deductions"

        public var id: Self { self }
    }
}

public extension Deduction {
    func getType() -> DeductionType {
        DeductionType(rawValue: type ?? "") ?? .preTaxDeductions
    }

    func getAmountType() -> AmountType {
        AmountType(rawValue: amountType ?? "") ?? .fixedAmount
    }
}
