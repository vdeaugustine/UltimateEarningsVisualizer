//
//  TodayViewNewTimeBlockCreation.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/22/23.
//

import CoreData
import Foundation
import SwiftUI

class TodayViewNewTimeBlockCreationModel: CreateNewTimeBlockViewModel {
    init(todayShift: TodayShift, start: Date? = nil, end: Date? = nil) {
        super.init(shift: todayShift)
        if let start{
            self.start = start
        }
        if let end {
            self.end = end
        }
    }

    override func saveAction(context: NSManagedObjectContext) throws {
        try saveCheck()

        do {
            try TimeBlock(title: title,
                          start: start,
                          end: end,
                          colorHex: selectedColorHex,
                          todayShift: shift as? TodayShift,
                          user: user,
                          context: context)
            print("Successful")
        } catch {
            throw SavingError.couldNotSaveContext
        }
    }
}
