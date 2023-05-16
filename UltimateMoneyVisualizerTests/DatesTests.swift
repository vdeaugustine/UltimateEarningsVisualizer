//
//  DatesTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/15/23.
//

import UltimateMoneyVisualizer
import XCTest

final class DatesTests: XCTestCase {
    let dateFormatter = DateFormatter()

    override func setUp() {
        super.setUp()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func testGroupDatesByWeek() {
        // Test case 1: Empty array
        let emptyArray: [Date] = []
        let emptyResult = Date.groupDatesByWeek(emptyArray)
        assert(emptyResult.isEmpty, "Test case 1 failed: Expected an empty result array.")

        // Test case 2: Dates in the same week
        let sameWeekDates: [Date] = [dateFormatter.date(from: "2023-05-10")!,
                                     dateFormatter.date(from: "2023-05-11")!,
                                     dateFormatter.date(from: "2023-05-12")!,
                                     dateFormatter.date(from: "2023-05-13")!]
        let sameWeekResult = Date.groupDatesByWeek(sameWeekDates)
        assert(sameWeekResult.count == 1, "Test case 2 failed: Expected a single subarray.")
        assert(sameWeekResult[0].count == 4, "Test case 2 failed: Expected all dates to be in the same subarray.")

        // Test case 3: Dates in different weeks
        let differentWeekDates: [Date] = [dateFormatter.date(from: "2023-05-10")!,
                                          dateFormatter.date(from: "2023-05-11")!,
                                          dateFormatter.date(from: "2023-05-18")!,
                                          dateFormatter.date(from: "2023-05-19")!]
        let differentWeekResult = Date.groupDatesByWeek(differentWeekDates)
        assert(differentWeekResult.count == 2, "Test case 3 failed: Expected two subarrays.")
        assert(differentWeekResult[0].count == 2, "Test case 3 failed: Expected first subarray to contain two dates.")
        assert(differentWeekResult[1].count == 2, "Test case 3 failed: Expected second subarray to contain two dates.")

        // Test case 4: Dates in the same week, but not in sorted order
        let unsortedDates: [Date] = [dateFormatter.date(from: "2023-05-13")!,
                                     dateFormatter.date(from: "2023-05-11")!,
                                     dateFormatter.date(from: "2023-05-12")!,
                                     dateFormatter.date(from: "2023-05-10")!]
        let unsortedResult = Date.groupDatesByWeek(unsortedDates)
        assert(unsortedResult.count == 1, "Test case 4 failed: Expected a single subarray.")
        assert(unsortedResult[0].count == 4, "Test case 4 failed: Expected all dates to be in the same subarray.")

        print("All test cases passed!")
    }

    func testGetStartAndEndOfWeek() {
        // Test case 1: Week starting on Sunday
        let date1 = dateFormatter.date(from: "2023-05-14")!
        let result1 = date1.getStartAndEndOfWeek()
        XCTAssertEqual(dateFormatter.string(from: result1.start), "2023-05-14")
        XCTAssertEqual(dateFormatter.string(from: result1.end), "2023-05-20")

        // Test case 3: Week starting on Friday
        let date3 = dateFormatter.date(from: "2023-05-19")!
        let result3 = date3.getStartAndEndOfWeek()
        XCTAssertEqual(dateFormatter.string(from: result3.start), "2023-05-14")
        XCTAssertEqual(dateFormatter.string(from: result3.end), "2023-05-20")

        // Test case 4: Week starting on Saturday
        let date4 = dateFormatter.date(from: "2023-05-20")!
        let result4 = date4.getStartAndEndOfWeek()
        XCTAssertEqual(dateFormatter.string(from: result4.start), "2023-05-14")
        XCTAssertEqual(dateFormatter.string(from: result4.end), "2023-05-20")
    }

    func testGroupShiftsByWeek() throws {
        let user = try User.getTestingUserWithExamples()

        // Group the shifts by week
        let (groupedShifts, sortedKeys) = user.groupShiftsByWeek()
        
        XCTAssertLessThanOrEqual(sortedKeys.count, 4, "too many shifts")

        // Iterate over the sorted keys and check the grouped shifts
        for key in sortedKeys {
            XCTAssertNotNil(groupedShifts[key], "Test failed: Grouped shifts not found for key: \(key)")
            if let weekShifts = groupedShifts[key] {
                XCTAssertTrue(!weekShifts.isEmpty, "Test failed: Week shifts should not be empty for key: \(key)")
                XCTAssertLessThanOrEqual(weekShifts.count, 7)
//                for shift in weekShifts {
//
//                }
            }
        }
    }
}
