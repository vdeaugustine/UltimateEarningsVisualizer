//
//  ExtendTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import CoreData
import Foundation
import Vin

extension TodayShift {
    func totalEarnedSoFar(_ nowTime: Date) -> Double {
        guard let startTime,
              let wage = user?.wage
        else { return 0 }

        let secondly = wage.secondly

        return secondly * (nowTime - startTime)
    }

    /// Amount of money that has already been allocated
    var allocated: Double {
        guard let allocs = Array(temporaryAllocations ?? []) as? [TemporaryAllocation] else { return 0 }
        return allocs.reduce(Double(0)) { $0 + $1.amount }
    }

    /// Amount of money available to be allocated
    func totalAvailable(_ nowTime: Date) -> Double {
        totalEarnedSoFar(nowTime) - allocated
    }

    /// Date.now - startTime. Measured in seconds
    func elapsedTime(_ nowTime: Date) -> Double {
        guard let startTime,
              nowTime > startTime else { return 0 }

        return nowTime - startTime
    }

    /// endTime - startTime. Measured in seconds
    var totalShiftDuration: Double {
        guard let startTime,
              let endTime else { return 0 }
        return endTime - startTime
    }

    /// Based on total duration x wage.secondly
    var totalWillEarn: Double {
        totalShiftDuration * (user?.wage?.secondly ?? 0)
    }

    func remainingTime(_ nowTime: Date) -> Double {
        totalShiftDuration - elapsedTime(nowTime)
    }

    func remainingToEarn(_ nowTime: Date) -> Double {
        remainingTime(nowTime) * (user?.wage?.secondly ?? 0)
    }
    
    
    func percentTimeCompleted(_ nowTime: Date) -> Double {
        let percent = elapsedTime(nowTime) / totalShiftDuration
        return percent < 1 ? percent : 1
    }
}
