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

    let wageValues: [(hourlyWage: Double, expectedSecondly: Double, expectedMinutely: Double, expectedDaily: Double, expectedWeekly: Double, expectedMonthly: Double, expectedYearly: Double)] = [(60, 0.0166666666666667, 1, 480, 2_400, 9_600, 115_200),
                                                                                                                                                                                                      (72, 0.02, 1.2, 576, 2_880, 11_520, 138_240),
                                                                                                                                                                                                      (27, 0.0075, 0.45, 216, 1_080, 4_320, 51_840),
                                                                                                                                                                                                      (68, 0.0188888888888888, 1.13333333333333, 544, 2_720, 10_880, 130_560),
                                                                                                                                                                                                      (18, 0.005, 0.3, 144, 720, 2_880, 34_560),
                                                                                                                                                                                                      (65, 0.0180555555555555, 1.08333333333333, 520, 2_600, 10_400, 124_800),
                                                                                                                                                                                                      (39, 0.0108333333333333, 0.65, 312, 1_560, 6_240, 74_880)]


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
        XCTAssertEqual(user.getWage().perYear, 115_200, accuracy: 0.0001)
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
