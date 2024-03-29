//
//  TodayShiftTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import UltimateMoneyVisualizer
import Vin
import XCTest

// MARK: - TestExpense

struct TempTodayPayoff: Identifiable, Equatable {
    var amount: Double
    var amountPaidOff: Double
    var amountRemaining: Double { amount - amountPaidOff }
    var title: String
    let id: UUID

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.amountPaidOff == rhs.amountPaidOff
    }

    init(expense: Expense) {
        self.amount = expense.amount
        self.amountPaidOff = expense.amountPaidOff
        self.title = expense.titleStr
        self.id = expense.getID()
    }

    init(goal: Goal) {
        self.amount = goal.amount
        self.amountPaidOff = goal.amountPaidOff
        self.title = goal.titleStr
        self.id = goal.getID()
    }

    init(amount: Double, amountPaidOff: Double, title: String, id: UUID) {
        self.amount = amount
        self.amountPaidOff = amountPaidOff
        self.id = id
        self.title = title
    }
}

func payOffExpenses(with amount: Double, expenses: [TempTodayPayoff]) -> [TempTodayPayoff] {
    var newExp: [TempTodayPayoff] = []
    var remainingAmount = amount

    for (index, expense) in expenses.enumerated() {
        var thisExp = expense
        let amountToPayOff = min(remainingAmount, expense.amountRemaining)
        thisExp.amountPaidOff += amountToPayOff
        remainingAmount -= amountToPayOff
        newExp.append(thisExp)

        if remainingAmount <= 0 {
            
            let countDifference = expenses.count - newExp.count
            if countDifference != 0 {
                newExp += expenses.suffixArray(countDifference)
            }
            break
        }
    }
    
    

    return newExp
}

import XCTest

// MARK: - PayoffExpenseTests

class PayoffExpenseTests: XCTestCase {
    let testExpenses = [
            TempTodayPayoff(amount: 100.0, amountPaidOff: 50.0, title: "Groceries", id: UUID()),
            TempTodayPayoff(amount: 50.0, amountPaidOff: 0, title: "Gas", id: UUID()),
            TempTodayPayoff(amount: 200.0, amountPaidOff: 150.0, title: "Rent", id: UUID()),
            TempTodayPayoff(amount: 25.0, amountPaidOff: 24.0, title: "Coffee", id: UUID()),
            TempTodayPayoff(amount: 75.0, amountPaidOff: 25.0, title: "Dinner", id: UUID())
        ]

    func testPayOffExpenses() {
        let result = payOffExpenses(with: 124, expenses: testExpenses)
        let expected = [TempTodayPayoff(amount: 100.0, amountPaidOff: 100.0, title: "Groceries", id: testExpenses[0].id),
                        TempTodayPayoff(amount: 50.0, amountPaidOff: 50.0, title: "Gas", id: testExpenses[1].id),
                        TempTodayPayoff(amount: 200.0, amountPaidOff: 174.0, title: "Rent", id: testExpenses[2].id),
                        TempTodayPayoff(amount: 25.0, amountPaidOff: 24.0, title: "Coffee", id: testExpenses[3].id),
                        TempTodayPayoff(amount: 75.0, amountPaidOff: 25.0, title: "Dinner", id: testExpenses[4].id)]
        
        for i in 0 ..< expected.count {
            XCTAssertEqual(result[i], expected[i])
        }
        
    }

//    func testPayOffExpensesWithZeroAmount() {
//        let result = payOffExpenses(with: 0.0, expenses: testExpenses)
//        XCTAssertEqual(result, testExpenses)
//    }
//
//    func testPayOffExpensesWithExceedingAmount() {
//        let result = payOffExpenses(with: 1000.0, expenses: testExpenses)
//        let expected = [
//            TestExpense(amount: 100.0, amountPaidOff: 100.0, title: "Groceries", id: testExpenses[0].id),
//            TestExpense(amount: 50.0, amountPaidOff: 0, title: "Gas", id: testExpenses[1].id),
//            TestExpense(amount: 200.0, amountPaidOff: 150.0, title: "Rent", id: testExpenses[2].id),
//            TestExpense(amount: 25.0, amountPaidOff: 25.0, title: "Coffee", id: testExpenses[3].id),
//            TestExpense(amount: 75.0, amountPaidOff: 75.0, title: "Dinner", id: testExpenses[4].id)
//        ]
//        XCTAssertEqual(result, expected)
//    }
//
//    func testPayOffExpensesWithMultiplePayments() {
//        var expenses = testExpenses
//        var result = payOffExpenses(with: 50.0, expenses: expenses)
//        var expected = [
//            TestExpense(amount: 100.0, amountPaidOff: 50.0, title: "Groceries", id: testExpenses[0].id),
//            TestExpense(amount: 50.0, amountPaidOff: 0, title: "Gas", id: testExpenses[1].id),
//            TestExpense(amount: 200.0, amountPaidOff: 150.0, title: "Rent", id: testExpenses[2].id),
//            TestExpense(amount: 25.0, amountPaidOff: 25.0, title: "Coffee", id: testExpenses[3].id),
//            TestExpense(amount: 75.0, amountPaidOff: 25.0, title: "Dinner", id: testExpenses[4].id)
//        ]
//        XCTAssertEqual(result, expected)
//
//        expenses = expected
//        result = payOffExpenses(with: 75.0, expenses: expenses)
//        expected = [
//            TestExpense(amount: 100.0, amountPaidOff: 100.0, title: "Groceries", id: testExpenses[0].id),
//            TestExpense(amount: 50.0, amountPaidOff: 0, title: "Gas", id: testExpenses[1].id),
//            TestExpense(amount: 200.0, amountPaidOff: 150.0, title: "Rent", id: testExpenses[2].id),
//            TestExpense(amount: 25.0, amountPaidOff: 25.0, title: "Coffee", id: testExpenses[3].id),
//            TestExpense(amount: 75.0, amountPaidOff: 75.0, title: "Dinner", id: testExpenses[4].id)
//        ]
//        XCTAssertEqual(result, expected)
//
//        expenses = expected
//        result = payOffExpenses(with: 75.0, expenses: expenses)
//        expected = [
//            TestExpense(amount: 100.0, amountPaidOff: 100.0, title: "Groceries", id: testExpenses[0].id),
//            TestExpense(amount: 50.0, amountPaidOff: 0, title: "Gas", id: testExpenses[1].id),
//            TestExpense(amount: 200.0, amountPaidOff: 150.0, title: "Rent", id: testExpenses[2].id),
//            TestExpense(amount: 25.0, amountPaidOff: 25.0, title: "Coffee", id: testExpenses[3].id),
//            TestExpense(amount: 75.0, amountPaidOff: 75.0, title: "Dinner", id: testExpenses[4].id)
//        ]
//        XCTAssertEqual(result, expected)
//    }
}

// MARK: - TodayShiftTests

final class TodayShiftTests: XCTestCase {
    let viewContext = PersistenceController.testing

    func createTodayShift(start: Date?, end: Date?) -> TodayShift {
        try! TodayShift(startTime: start ?? .now.addHours(-1),
                        endTime: end ?? .now.addHours(2),
                        user: User.main)
    }

    func createTemporaryAllocation() -> TemporaryAllocation {
        let allocation = TemporaryAllocation(context: PersistenceController.context)
        allocation.id = UUID()
        allocation.amount = 25
        _ = Goal(context: PersistenceController.context)

        return allocation
    }

    func testTotalEarnedSoFar() {
        let nowTime = Date()
        let shift = createTodayShift(start: .now.addMinutes(-30), end: .now.addMinutes(30))

        let expectedEarned: Double = 7.5
        XCTAssertEqual(shift.totalEarnedSoFar(nowTime), expectedEarned, accuracy: 0.01)
    }

    func testAllocated() {
        let shift = TodayShift(context: viewContext)
        let tempAlloc1 = TemporaryAllocation(context: viewContext)
        let tempAlloc2 = TemporaryAllocation(context: viewContext)
        tempAlloc1.amount = 25.0
        tempAlloc2.amount = 50.0
        shift.temporaryAllocations = NSSet(array: [tempAlloc1, tempAlloc2])

        XCTAssertEqual(shift.allocated, 75.0, accuracy: 0.001)
    }

    func testTotalAvailable() {
        let nowTime = Date()
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let tempAlloc = TemporaryAllocation(context: viewContext)
        tempAlloc.amount = 20.0
        shift.temporaryAllocations = NSSet(array: [tempAlloc])

        let expectedAvailable = 30.0 // 5 hours * 10 per hour = 50 dollars. 50 - 20 allocated = 30 dollars
        XCTAssertEqual(shift.totalAvailable(nowTime), expectedAvailable, accuracy: 0.001)
    }

    func testElapsedTime() {
        let nowTime = Date()
        let shift = TodayShift(context: viewContext)
        shift.startTime = Date.now.addHours(-2)
        shift.endTime = Date.now.addHours(1)
        let expectedElapsedTime: Double = 2 * 60 * 60 // 2 hours * 3600 seconds/hour
        XCTAssertEqual(shift.elapsedTime(nowTime), expectedElapsedTime, accuracy: 0.001)
    }

    func testTotalShiftDuration() {
        let shift = TodayShift(context: viewContext)
        shift.startTime = Date(timeIntervalSinceNow: -7_200) // 2 hours ago
        shift.endTime = Date()

        let expectedDuration = 7_200.0 // 2 hours * 3600 seconds/hour
        XCTAssertEqual(shift.totalShiftDuration, expectedDuration, accuracy: 0.001)
    }

    func testTotalWillEarn() {
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let wage = Wage(context: viewContext)
        wage.amount = 13.0
        shift.user = User(context: viewContext)
        shift.user?.wage = wage
        shift.startTime = Date.now.addHours(-3) // 3 hours ago
        shift.endTime = Date()

        let expectedEarnings = 39 // 3 hours * $13/hour
        XCTAssertEqual(shift.totalWillEarn, Double(expectedEarnings), accuracy: 0.001)
    }

    func testRemainingTime() {
        let nowTime = Date()
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        shift.startTime = Date.now.addHours(-1) // 1 hour ago
        shift.endTime = Date.now.addHours(1) // 1 hour from now

        let expectedRemainingTime = 3_600.0 // 1 hour from now - 1 hour ago
        XCTAssertEqual(shift.remainingTime(nowTime), expectedRemainingTime, accuracy: 0.001)

        shift.endTime = Date.now.addHours(4) // 2 hours ago
        let expectedRemainingTime2: Double = 4 * 60 * 60 // negative time should return 0
        XCTAssertEqual(shift.remainingTime(nowTime), expectedRemainingTime2, accuracy: 0.001)
    }

    func testRemainingToEarn() {
        let nowTime = Date()
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        shift.startTime = Date.now.addHours(-1) // 1 hour ago
        shift.endTime = Date.now.addHours(1) // 1 hour from now
        let wage = Wage(context: viewContext)
        wage.amount = 15.0
        shift.user = User(context: viewContext)
        shift.user?.wage = wage

        let expectedRemainingToEarn: Double = 15 // 3600 seconds * $15/3600 seconds/hour
        XCTAssertEqual(shift.remainingToEarn(nowTime), expectedRemainingToEarn, accuracy: 0.001)

        shift.endTime = Date.now.addHours(4) // 2 hours ago
        let expectedRemainingToEarn2: Double = 4 * 15 // negative time should return 0
        XCTAssertEqual(shift.remainingToEarn(nowTime), expectedRemainingToEarn2, accuracy: 0.001)
    }

    func testPercentTimeCompleted() {
        let nowTime = Date()
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        shift.startTime = Date(timeIntervalSinceNow: -3_600) // 1 hour ago
        shift.endTime = Date(timeIntervalSinceNow: 3_600) // 1 hour from now

        let expectedPercentTimeCompleted = 0.5 // elapsed time = 1 hour, total duration = 2 hours, 1/2 = 0.5
        XCTAssertEqual(shift.percentTimeCompleted(nowTime), expectedPercentTimeCompleted, accuracy: 0.001)

        shift.startTime = Date(timeIntervalSinceNow: -7_200) // 2 hours ago
        shift.endTime = Date(timeIntervalSinceNow: -3_600) // 1 hour ago
        let expectedPercentTimeCompleted2 = 1.0 // elapsed time = 1 hour, total duration = 1 hour, 1/1 = 1
        XCTAssertEqual(shift.percentTimeCompleted(nowTime), expectedPercentTimeCompleted2, accuracy: 0.001)

        shift.startTime = Date(timeIntervalSinceNow: 3_600) // 1 hour from now
        shift.endTime = Date(timeIntervalSinceNow: 7_200) // 2 hours from now
        let expectedPercentTimeCompleted3 = 0.0 // elapsed time = 0, total duration = 1 hour, 0/1 = 0
        XCTAssertEqual(shift.percentTimeCompleted(nowTime), expectedPercentTimeCompleted3, accuracy: 0.001)
    }

    // Test for addTemporaryAllocation method
    func testAddTemporaryAllocation() {
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let allocation = createTemporaryAllocation()

        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation, context: viewContext))
        XCTAssertEqual(shift.temporaryAllocations?.count, 1)
        XCTAssertEqual(shift.getPayoffItemQueue(), [allocation.id!.uuidString])
    }

    // Test for makePayoffItemQueueStr method
    func testmakeInitialPayoffItemQueueStr() {
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let allocation1 = createTemporaryAllocation()
        let allocation2 = createTemporaryAllocation()

        XCTAssertNil(shift.makeInitialPayoffItemQueueStr())

        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation1, context: viewContext))
        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation2, context: viewContext))

        XCTAssertEqual(shift.makeInitialPayoffItemQueueStr(), "\(allocation1.id!.uuidString),\(allocation2.id!.uuidString)")
    }

    // Test for getPayoffItemQueue method
    func testGetPayoffItemQueue() {
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let allocation1 = createTemporaryAllocation()
        let allocation2 = createTemporaryAllocation()

        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation1, context: viewContext))
        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation2, context: viewContext))

        XCTAssertEqual(shift.getPayoffItemQueue(), [allocation1.id!.uuidString, allocation2.id!.uuidString])
    }

    // Test for deleteTemporaryAllocation method
    func testDeleteTemporaryAllocation() {
        let shift = createTodayShift(start: .now.addHours(-5), end: .now.addHours(1))
        let allocation1 = createTemporaryAllocation()
        let allocation2 = createTemporaryAllocation()

        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation1, context: viewContext))
        XCTAssertNoThrow(try shift.addTemporaryAllocation(allocation2, context: viewContext))

        XCTAssertNoThrow(try shift.deleteTemporaryAllocation(allocation1))

        XCTAssertEqual(shift.temporaryAllocations?.count, 1)
        XCTAssertEqual(shift.getPayoffItemQueue(), [allocation2.id!.uuidString])
    }
}
