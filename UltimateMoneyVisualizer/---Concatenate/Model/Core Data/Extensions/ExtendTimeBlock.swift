//
//  ExtendTimeBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

extension TimeBlock {
    @discardableResult convenience init(title: String,
                                        start: Date,
                                        end: Date,
                                        colorHex: String,
                                        shift: Shift,
                                        user: User,
                                        context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.title = title
        self.startTime = start
        self.endTime = end
        self.colorHex = colorHex
        self.user = user
        user.addToTimeBlocks(self)
        self.dateCreated = Date.now
        self.shift = shift
        shift.addToTimeBlocks(self)
        try context.save()
    }
}

extension TimeBlock {
    var duration: TimeInterval {
        guard let startTime, let endTime else { return 0 }
        return endTime - startTime
    }

    func amountEarned() -> Double {
        let perSecond = User.main.getWage().perSecond
        return duration * perSecond
    }

    func getColor() -> Color {
        guard let colorHex else { return Color(hex: "#003649") }
        return Color.hexStringToColor(hex: colorHex)
    }
}
