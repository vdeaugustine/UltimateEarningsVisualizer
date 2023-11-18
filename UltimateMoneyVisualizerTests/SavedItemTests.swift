//
//  TestSavedItems.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 4/30/23.
//

import CoreData
import UltimateMoneyVisualizer
import Vin
import XCTest

final class SavedItemTests: XCTestCase {
    let context = PersistenceController.testing
    let user = User(context: PersistenceController.testing)

    func testTotalDollarsSaved() throws {
        try Saved(amount: 20, title: "Lunch", date: .init(fromString: "02/04/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 15, title: "No Movies", date: .init(fromString: "02/19/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 7, title: "Rode bike", date: .init(fromString: "02/1/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 9, title: "Friend bought dinner", date: .init(fromString: "02/27/2023", format: "MM/dd/yyyy")!, user: user, context: context)

        let expected: Double = 20 + 15 + 7 + 9

        XCTAssertEqual(expected, user.totalDollarsSaved())
    }
    
    func testTotalTimeSaved() throws {

        try Saved(amount: 20, title: "Lunch", date: .init(fromString: "02/04/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 15, title: "No Movies", date: .init(fromString: "02/19/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 7, title: "Rode bike", date: .init(fromString: "02/1/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        try Saved(amount: 9, title: "Friend bought dinner", date: .init(fromString: "02/27/2023", format: "MM/dd/yyyy")!, user: user, context: context)

        try Wage(amount: 60,
                      isSalary: false,
                      user: user,
                      includeTaxes: false,
                      stateTax: nil,
                      federalTax: nil,
                      context: PersistenceController.testing)

        let timeSaved = user.totalTimeSaved()

        XCTAssertEqual(9179.99999999999, timeSaved, accuracy: 0.0001)

    }
    
    
    
}
