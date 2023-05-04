//
//  ExpenseTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import UltimateMoneyVisualizer
import Vin
import XCTest

final class ExpenseTests: XCTestCase {
    let user = User.testing
    let context = PersistenceController.testing
    func testTemporarilyPaidOff() throws {
        

        let expense = Expense(title: "Groceries", info: "For the week", amount: 50, dueDate: .now.addDays(25), user: user, context: context)

        try TodayShift(startTime: .nineAM, endTime: .fivePM, user: user, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, context: context)

        try TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        try TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedAllocated: Double = 20 + 8 + 7

        XCTAssertEqual(expense.temporarilyPaidOff, expectedAllocated, accuracy: 0.01)
    }

    func testTemporaryRemainingToPayOff() throws {
        let expense = Expense(title: "Groceries", info: "For the week", amount: 93, dueDate: .now.addDays(25), user: user, context: context)

        _ = try TodayShift(startTime: .nineAM, endTime: .fivePM, user: user, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, context: context)

        _ = try TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        _ = try TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        _ = try TemporaryAllocation(initialAmount: 4, expense: expense, context: context)
        _ = Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedRemaining: Double = 93 - 20 - 8 - 4 - 7

        XCTAssertEqual(expectedRemaining, expense.temporaryRemainingToPayOff)
    }
}
