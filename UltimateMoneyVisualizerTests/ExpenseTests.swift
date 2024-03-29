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
        let expense = try Expense(title: "Groceries",
                              info: "For the week",
                              amount: 50,
                              dueDate: .now.addDays(25),
                              dateCreated: .now,
                              isRecurring: false,
                              recurringDate: nil,
                              tagStrings: nil,
                              repeatFrequency: nil,
                              user: user,
                              context: context)

        /* Expense(title: "Groceries", info: "For the week", amount: 50, dueDate: .now.addDays(25), user: user, context: context) */

        try TodayShift(startTime: .nineAM, endTime: .fivePM, user: user, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, user: user, context: context)

        try TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        try TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        try Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedAllocated: Double = 20 + 8 + 7

        XCTAssertEqual(expense.temporarilyPaidOff, expectedAllocated, accuracy: 0.01)
    }

    func testTemporaryRemainingToPayOff() throws {
        let expense = try Expense(title: "Groceries",
                                  info: "For the week",
                                  amount: 50,
                                  dueDate: .now.addDays(25),
                                  dateCreated: .now,
                                  isRecurring: false,
                                  recurringDate: nil,
                                  tagStrings: nil,
                                  repeatFrequency: nil,
                                  user: user,
                                  context: context)

        try TodayShift(startTime: .nineAM, endTime: .fivePM, user: user, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, user: user, context: context)

        try TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        try TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        try TemporaryAllocation(initialAmount: 4, expense: expense, context: context)
        try Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedRemaining: Double = 93 - 20 - 8 - 4 - 7

        XCTAssertEqual(expectedRemaining, expense.temporaryRemainingToPayOff)
    }
}
