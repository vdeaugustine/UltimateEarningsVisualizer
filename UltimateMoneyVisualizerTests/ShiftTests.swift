//
//  ShiftTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/15/23.
//

import UltimateMoneyVisualizer
import XCTest
import CoreData

final class ShiftTests: XCTestCase {
    var user: User!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let pc = PersistenceController(inMemory: true)
        self.context = pc.container.viewContext
        user = User(context: self.context)
    }
    
    override func tearDown() {
        super.tearDown()
            
            // Assuming User and Shift are NSManagedObject subclasses
            let fetchRequestUser: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
            let fetchRequestShift: NSFetchRequest<NSFetchRequestResult> = Shift.fetchRequest()
            
            let deleteRequestUser = NSBatchDeleteRequest(fetchRequest: fetchRequestUser)
            let deleteRequestShift = NSBatchDeleteRequest(fetchRequest: fetchRequestShift)
            
            do {
                try context.execute(deleteRequestUser)
                try context.execute(deleteRequestShift)
            } catch {
                print("There was an error cleaning up test data: \(error)")
            }
            
            user = nil
            context = nil
    }

    func testNoShifts() {
        XCTAssertTrue(user.getDuplicateShifts().isEmpty)
    }
    
   

    func testSingleShift() throws {
        try Shift(day: .monday, start: Date(), end: Date().addingTimeInterval(3_600), user: user, context: context)
        XCTAssertTrue(user.getDuplicateShifts().isEmpty)
    }

    func testTwoDifferentShifts() throws {
        try Shift(day: .monday, start: Date(), end: Date().addingTimeInterval(3_600), user: user, context: context)
        try Shift(day: .tuesday, start: Date().addingTimeInterval(7_200), end: Date().addingTimeInterval(10_800), user: user, context: context)
        XCTAssertTrue(user.getDuplicateShifts().isEmpty)
    }

    func testTwoIdenticalShifts() throws {
        let start = Date()
        let end = Date().addHours(4)
        try Shift(day: .monday, start: start, end: end, user: user, context: context)
        try Shift(day: .monday, start: start, end: end, user: user, context: context)
        XCTAssertEqual(user.getDuplicateShifts().count, 1)
    }

    func testMultipleIdenticalShifts() throws {
        let start = Date()
        let end = Date().addHours(3)
        for _ in 0 ..< 5 {
            try Shift(day: .monday, start: start, end: end, user: user, context: context)
        }
        XCTAssertEqual(user.getDuplicateShifts().count, 4) // 4 duplicates of the original
    }

    func testMixedShifts() throws {
        
        let start = Date()
        let end = Date().addHours(9)
        
        for _ in 0 ..< 3 {
            try Shift(day: .monday, start: start, end: end, user: user, context: context)
        }
        try Shift(day: .tuesday, start: Date().addingTimeInterval(7_200), end: Date().addingTimeInterval(10_800), user: user, context: context)
        XCTAssertEqual(user.getDuplicateShifts().count, 2)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
