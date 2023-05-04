//
//  WageTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/3/23.
//

import CoreData
import UltimateMoneyVisualizer
import Vin
import XCTest

final class WageTests: XCTestCase {
    let user: User = {
        let ux = User(context: PersistenceController.testing)
        let wage = try! Wage(amount: 60,
                             user: ux, context: PersistenceController.testing)
        ux.wage = wage
        try! PersistenceController.testing.save()
        return ux
    }()

    let wageValues: [(hourlyWage: Double, expectedSecondly: Double, expectedMinutely: Double, expectedDaily: Double, expectedWeekly: Double, expectedMonthly: Double, expectedYearly: Double)] = [(60, 0.0166666666666667, 1, 480, 2_400, 9_600, 124_800), (10, 0.00277777777777778, 0.166666666666667, 80, 400, 1_600, 20_800), (29, 0.00805555555555555, 0.483333333333333, 232, 1_160, 4_640, 60_320), (10, 0.00277777777777778, 0.166666666666667, 80, 400, 1_600, 20_800), (90, 0.025, 1.5, 720, 3_600, 14_400, 187_200), (44, 0.0122222222222222, 0.733333333333333, 352, 1_760, 7_040, 91_520), (46, 0.0127777777777778, 0.766666666666667, 368, 1_840, 7_360, 95_680)]



    func testSecondly() throws {
        XCTAssertEqual(user.getWage().secondly, user.getWage().perSecond, accuracy: 0.0001)
    }

    // Tests for `wagePerSecond` extension
    func testWagePerSecond() {
        XCTAssertEqual(user.getWage().perSecond, 0.0166666666666667, accuracy: 0.0001)
    }

    // Tests for `wagePerMinute` extension
    func testWagePerMinute() {
        XCTAssertEqual(user.getWage().perMinute, 1, accuracy: 0.0001)
    }

    // Tests for `wagePerDay` extension
    func testWagePerDay() {
        XCTAssertEqual(user.getWage().perDay, 480, accuracy: 0.0001)
    }

    // Tests for `wagePerWeek` extension
    func testWagePerWeek() {
        XCTAssertEqual(user.getWage().perWeek, 2_400, accuracy: 0.0001)
    }

    // Tests for `wagePerMonth` extension
    func testWagePerMonth() {
        XCTAssertEqual(user.getWage().perMonth, 9_600, accuracy: 0.0001)
    }

    // Tests for `wagePerYear` extension
    func testWagePerYear() {
        XCTAssertEqual(user.getWage().perYear, 124800, accuracy: 0.0001)
    }

    func testWageValues() {
        for wageValue in wageValues {
            let user = createUser(with: wageValue.hourlyWage)
            XCTAssertEqual(user.getWage().secondly, wageValue.expectedSecondly, accuracy: 0.0001)
            XCTAssertEqual(user.getWage().perMinute, wageValue.expectedMinutely, accuracy: 0.0001)
            XCTAssertEqual(user.getWage().perDay, wageValue.expectedDaily, accuracy: 0.0001)
            XCTAssertEqual(user.getWage().perWeek, wageValue.expectedWeekly, accuracy: 0.0001)
            XCTAssertEqual(user.getWage().perMonth, wageValue.expectedMonthly, accuracy: 0.0001)
            XCTAssertEqual(user.getWage().perYear, wageValue.expectedYearly, accuracy: 0.0001)
        }
    }

    func createUser(with hourlyWage: Double) -> User {
        let user = User(context: PersistenceController.testing)
        let wage = try! Wage(amount: hourlyWage,
                             user: user, context: PersistenceController.testing)
        user.wage = wage
        try! PersistenceController.testing.save()
        return user
    }
}
