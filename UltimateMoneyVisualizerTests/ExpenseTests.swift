//
//  ExpenseTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import XCTest
import Vin
import UltimateMoneyVisualizer

final class ExpenseTests: XCTestCase {
    
    func testTemporarilyPaidOff() throws {
            
        let context = PersistenceController.testing
        
        let expense = Expense(title: "Groceries", info: "For the week", amount: 50, dueDate: .now.addDays(25), context: context)
        
        let todayShift = TodayShift(startTime: .nineAM, endTime: .fivePM, context: context)
        
        _ = TemporaryAllocation(todayShift: todayShift, initialAmount: 20, expense: expense, context: context)
        _ = TemporaryAllocation(todayShift: todayShift, initialAmount: 8, expense: expense, context: context)
        
        let expectedAllocated: Double = 20 + 8
        
        XCTAssertEqual(expense.temporarilyPaidOff, expectedAllocated, accuracy: 0.01)
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
