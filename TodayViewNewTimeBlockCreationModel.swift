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
    
    init(todayShift: TodayShift) {
        super.init(shift: todayShift)
    }

    override func saveAction(context: NSManagedObjectContext) {
        do {
            try TimeBlock(title: title,
                          start: start,
                          end: end,
                          colorHex: selectedColorHex,
                          todayShift: shift as? TodayShift,
                          user: user,
                          context: context)
        } catch {
            print("Error saving time block")
        }
    }
}
