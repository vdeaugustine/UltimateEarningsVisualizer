//
//  UserFunctionsTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import CoreData
import UltimateMoneyVisualizer
import Vin
import XCTest

final class UserFunctionsTests: XCTestCase {
    let context = PersistenceController.testing
    
    func printThisShift(_ shift: Shift) {
        print("Shift", shift.dayOfWeek!,
              shift.startDate!.getFormattedDate(format: "yyyy/MM/dd HH:mm"),
              shift.endDate!.getFormattedDate(format: "yyyy/MM/dd HH:mm")
        )
    }
    
    func printShifts(_ shifts: [Shift]) {
        for shift in shifts {
            printThisShift(shift)
        }
    }

    func testGetShiftsBetween() throws {
        let user = User(context: context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        let shifts = [try Shift(day: .monday, start: dateFormatter.date(from: "2023/05/01 09:00")!, end: dateFormatter.date(from: "2023/05/01 17:00")!, user: user, context: context),
                      try Shift(day: .tuesday, start: dateFormatter.date(from: "2023/05/02 09:00")!, end: dateFormatter.date(from: "2023/05/02 17:00")!, user: user, context: context),
                      try Shift(day: .wednesday, start: dateFormatter.date(from: "2023/05/03 09:00")!, end: dateFormatter.date(from: "2023/05/03 17:00")!, user: user, context: context),
                      try Shift(day: .thursday, start: dateFormatter.date(from: "2023/05/04 09:00")!, end: dateFormatter.date(from: "2023/05/04 17:00")!, user: user, context: context),
                      try Shift(day: .friday, start: dateFormatter.date(from: "2023/05/05 09:00")!, end: dateFormatter.date(from: "2023/05/05 17:00")!, user: user, context: context)]


        print("----- User's shifts created -------")
        printShifts(shifts)
        print("------User's shifts saved --------")
        printShifts(user.getShifts())
        
        // Test case 1: Shifts between two dates
        let startDate1 = dateFormatter.date(from: "2023/05/02 00:00")!
        let endDate1 = dateFormatter.date(from: "2023/05/04 23:59")!
        let result1 = user.getShiftsBetween(startDate: startDate1, endDate: endDate1)
        XCTAssertEqual(result1.count, 3, "Should return 3 shifts")

        // Test case 2: Shifts between two dates with no shifts
        let startDate2 = dateFormatter.date(from: "2023/04/28 00:00")!
        let endDate2 = dateFormatter.date(from: "2023/04/30 00:00")!
        let result2 = user.getShiftsBetween(startDate: startDate2, endDate: endDate2)
        XCTAssertEqual(result2.count, 0, "Should return 0 shifts")

        // Test case 3: Shifts between two identical dates
        let startDate3 = dateFormatter.date(from: "2023/05/01 00:00")!
        let endDate3 = dateFormatter.date(from: "2023/05/01 00:00")!
        let result3 = user.getShiftsBetween(startDate: startDate3, endDate: endDate3)
        XCTAssertEqual(result3.count, 0, "Should return 0 shifts")

        // Test case 4: Shifts with one date outside the range
        let startDate4 = dateFormatter.date(from: "2023/05/03 12:00")!
        let endDate4 = dateFormatter.date(from: "2023/05/05 8:59")!
        let result4 = user.getShiftsBetween(startDate: startDate4, endDate: endDate4)
        print("--------Fetched shifts from function --------")
        printShifts(result4)
        XCTAssertEqual(result4.count, 2, "Should return 2 shifts")

        // Test case 5: Shifts with both dates inside the range
        let startDate5 = dateFormatter.date(from: "2023/05/03 12:00")!
        let endDate5 = dateFormatter.date(from: "2023/05/04 12:00")!
        let result5 = user.getShiftsBetween(startDate: startDate5, endDate: endDate5)
        XCTAssertEqual(result5.count, 2, "Should return 2 shifts")

        // Test case 6: Shifts with start and end dates exactly matching the shifts
        let startDate6 = dateFormatter.date(from: "2023/05/01 09:00")!
        let endDate6 = dateFormatter.date(from: "2023/05/01 17:00")!
        let result6 = user.getShiftsBetween(startDate: startDate6, endDate: endDate6)
        XCTAssertEqual(result6.count, 1, "Should return 1 shift")

//        // Test case 7: Invalid date range (start date greater than end date)
//        let startDate7 = dateFormatter.date(from: "2023/05/04 00:00")!
//        let endDate7 = dateFormatter.date(from: "2023/05/02 00:00")!
//        let result7 = user.getShiftsBetween(startDate7, endDate7)
//        XCTAssertEqual(result7.count, 0, "Should return 0 shifts")

        // Test case 8: Shifts with overnight shifts
        user.addToShifts(try! Shift(day: .friday, start: dateFormatter.date(from: "2023/05/06 22:00")!, end: dateFormatter.date(from: "2023/05/07 06:00")!, user: user, context: context))
        let startDate8 = dateFormatter.date(from: "2023/05/06 00:00")!
        let endDate8 = dateFormatter.date(from: "2023/05/07 00:00")!
        let result8 = user.getShiftsBetween(startDate: startDate8, endDate: endDate8)
        XCTAssertEqual(result8.count, 1, "Should return 1 shift")

        // Test case 9: Shifts with overlapping shifts
        user.addToShifts(try Shift(day: .monday, start: dateFormatter.date(from: "2023/05/08 08:00")!, end: dateFormatter.date(from: "2023/05/08 12:00")!, user: user, context: context))
        user.addToShifts(try Shift(day: .monday, start: dateFormatter.date(from: "2023/05/08 10:00")!, end: dateFormatter.date(from: "2023/05/08 14:00")!, user: user, context: context))
        let startDate9 = dateFormatter.date(from: "2023/05/08 00:00")!
        let endDate9 = dateFormatter.date(from: "2023/05/09 00:00")!
        let result9 = user.getShiftsBetween(startDate: startDate9, endDate: endDate9)
        XCTAssertEqual(result9.count, 2, "Should return 2 shifts")
    }
}
