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
    func testTemporarilyPaidOff() throws {
        let context = PersistenceController.testing

        let expense = Expense(title: "Groceries", info: "For the week", amount: 50, dueDate: .now.addDays(25), context: context)

        let todayShift = TodayShift(startTime: .nineAM, endTime: .fivePM, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, context: context)

        _ = TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        _ = TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        _ = Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedAllocated: Double = 20 + 8 + 7

        XCTAssertEqual(expense.temporarilyPaidOff, expectedAllocated, accuracy: 0.01)
    }

    func testTemporaryRemainingToPayOff() throws {
        let context = PersistenceController.testing

        let expense = Expense(title: "Groceries", info: "For the week", amount: 93, dueDate: .now.addDays(25), context: context)

        let todayShift = TodayShift(startTime: .nineAM, endTime: .fivePM, context: context)
        let shiftForAllocation = try Shift(day: .monday, start: .nineAM, end: .fivePM, context: context)

        _ = TemporaryAllocation(initialAmount: 20, expense: expense, context: context)
        _ = TemporaryAllocation(initialAmount: 8, expense: expense, context: context)
        _ = TemporaryAllocation(initialAmount: 4, expense: expense, context: context)
        _ = Allocation(amount: 7, expense: expense, shift: shiftForAllocation, context: context)

        let expectedRemaining: Double = 93 - 20 - 8 - 4 - 7

        XCTAssertEqual(expectedRemaining, expense.temporaryRemainingToPayOff)
    }

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
