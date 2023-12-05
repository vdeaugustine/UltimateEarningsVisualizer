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
        
        self.start = start ?? todayShift.startTime ?? .nineAM
        self.end = end ?? todayShift.endTime ?? .fivePM
    }


    override func saveAction(context: NSManagedObjectContext) throws {
        try saveCheck()
        
        guard let todayShift = shift as? TodayShift else {
            throw SavingError.couldNotGetTodayShift
        }

        do {
            try TimeBlock(title: title,
                          start: start,
                          end: end,
                          colorHex: selectedColorHex,
                          todayShift: todayShift,
                          user: user,
                          context: context)
            print("Successful")
            print("printing")
            for timeBlock in todayShift.getTimeBlocks() {
                print(timeBlock)
            }
        } catch {
            throw SavingError.couldNotSaveContext
        }
    }
}
