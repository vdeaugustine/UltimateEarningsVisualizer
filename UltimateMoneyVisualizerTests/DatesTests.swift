//
//  DatesTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/15/23.
//

import XCTest
import UltimateMoneyVisualizer




final class DatesTests: XCTestCase {

    func testGroupDatesByWeek() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Test case 1: Empty array
        let emptyArray: [Date] = []
        let emptyResult = groupDatesByWeek(emptyArray)
        assert(emptyResult.isEmpty, "Test case 1 failed: Expected an empty result array.")
        
        // Test case 2: Dates in the same week
        let sameWeekDates: [Date] = [
            dateFormatter.date(from: "2023-05-10")!,
            dateFormatter.date(from: "2023-05-11")!,
            dateFormatter.date(from: "2023-05-12")!,
            dateFormatter.date(from: "2023-05-13")!,
        ]
        let sameWeekResult = groupDatesByWeek(sameWeekDates)
        assert(sameWeekResult.count == 1, "Test case 2 failed: Expected a single subarray.")
        assert(sameWeekResult[0].count == 4, "Test case 2 failed: Expected all dates to be in the same subarray.")
        
        // Test case 3: Dates in different weeks
        let differentWeekDates: [Date] = [
            dateFormatter.date(from: "2023-05-10")!,
            dateFormatter.date(from: "2023-05-11")!,
            dateFormatter.date(from: "2023-05-18")!,
            dateFormatter.date(from: "2023-05-19")!,
        ]
        let differentWeekResult = groupDatesByWeek(differentWeekDates)
        assert(differentWeekResult.count == 2, "Test case 3 failed: Expected two subarrays.")
        assert(differentWeekResult[0].count == 2, "Test case 3 failed: Expected first subarray to contain two dates.")
        assert(differentWeekResult[1].count == 2, "Test case 3 failed: Expected second subarray to contain two dates.")
        
        // Test case 4: Dates in the same week, but not in sorted order
        let unsortedDates: [Date] = [
            dateFormatter.date(from: "2023-05-13")!,
            dateFormatter.date(from: "2023-05-11")!,
            dateFormatter.date(from: "2023-05-12")!,
            dateFormatter.date(from: "2023-05-10")!,
        ]
        let unsortedResult = groupDatesByWeek(unsortedDates)
        assert(unsortedResult.count == 1, "Test case 4 failed: Expected a single subarray.")
        assert(unsortedResult[0].count == 4, "Test case 4 failed: Expected all dates to be in the same subarray.")
        
        print("All test cases passed!")
    }

    
    
    
    

}
