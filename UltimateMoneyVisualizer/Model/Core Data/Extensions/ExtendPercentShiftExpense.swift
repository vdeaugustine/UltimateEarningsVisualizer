//
//  ExtendPercentShiftExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/10/23.
//

import CoreData
import Foundation
import Vin

extension PercentShiftExpense {
    @discardableResult convenience init(title: String,
                                        percent: Double,
                                        shift: Shift? = nil,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        if let shift { addToShifts(shift) }
        self.title = title
        self.percent = percent
        self.user = user

        user.addToPercentShiftExpenses(self)

        try context.save()
    }

//    var totalAmount: Double {
//        guard let shifts
//        else { return 0 }
//        let willEarn = shift.totalEarned
//        return willEarn * percent
//    }

    func getTitle() -> String {
        title ?? ""
    }
}
