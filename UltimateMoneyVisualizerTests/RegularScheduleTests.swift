//
//  RegularScheduleTests.swift
//  UltimateMoneyVisualizerTests
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import XCTest
import UltimateMoneyVisualizer
import Vin

final class RegularScheduleTests: XCTestCase {
    
    

   
    func testDateToString() throws {
        
        
        
        
        let date = Date.stringToDate("12:32", of: Date.now)
        let x = Date.getThisTime(hour: 12, minute: 32, from: Date.now)
        XCTAssertEqual(date!, x!)
        
    }
    
    
    
    
    

}
