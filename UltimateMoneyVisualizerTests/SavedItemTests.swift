//
//  TestSavedItems.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 4/30/23.
//

import XCTest
import Vin
import UltimateMoneyVisualizer
import CoreData


final class SavedItemTests: XCTestCase {


    func testTotalSaved() throws {
        let context = PersistenceController.testing
        let user = User.testing
        let saved1 = try Saved(amount: 20, title: "Lunch", date: .init(fromString: "02/04/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        let saved2 = try Saved(amount: 15, title: "Lunch", date: .init(fromString: "02/19/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        let saved3 = try Saved(amount: 7, title: "Lunch", date: .init(fromString: "02/1/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        let saved4 = try Saved(amount: 9, title: "Lunch", date: .init(fromString: "02/27/2023", format: "MM/dd/yyyy")!, user: user, context: context)
        
        let expected: Double = 20 + 15 + 7 + 9
        
        XCTAssertEqual(expected, user.totalDollarsSaved())
        
    }
    
    
    
    
}
