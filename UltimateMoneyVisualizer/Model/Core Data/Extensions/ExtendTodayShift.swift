//
//  ExtendTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import AlertToast
import CoreData
import Foundation
import Vin

public extension TodayShift {
    /// endTime - startTime. Measured in seconds
    var totalShiftDuration: Double {
        guard let startTime,
              let endTime,
              endTime > startTime else { return 0 }
        return endTime - startTime
    }

    /// Based on total duration x wage.secondly
    var totalWillEarn: Double {
        totalShiftDuration * (user?.wage?.secondly ?? 0)
    }

    /// Date.now - startTime. Measured in seconds
    func elapsedTime(_ nowTime: Date) -> Double {
        guard let startTime,
              nowTime > startTime else { return 0 }
        return min(nowTime - startTime, totalShiftDuration)
    }

    func totalEarnedSoFar(_ nowTime: Date) -> Double {
        guard let wage = user?.wage else {
            return 0
        }

        return wage.secondly * elapsedTime(nowTime)
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

    func remainingTime(_ nowTime: Date) -> Double {
        let time = totalShiftDuration - elapsedTime(nowTime)
        return time >= 0 ? time : 0
    }

    func remainingToEarn(_ nowTime: Date) -> Double {
        let amount = remainingTime(nowTime) * (user?.wage?.secondly ?? 0)
        return amount >= 0 ? amount : 0
    }

    func percentTimeCompleted(_ nowTime: Date) -> Double {
        let percent = elapsedTime(nowTime) / totalShiftDuration
        return percent < 1 ? percent : 1
    }
}
