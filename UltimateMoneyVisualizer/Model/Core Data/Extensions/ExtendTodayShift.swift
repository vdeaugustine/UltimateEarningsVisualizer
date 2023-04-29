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
    convenience init(startTime: Date, endTime: Date, context: NSManagedObjectContext = PersistenceController.context) {
        let context = PersistenceController.context
        self.init(context: context)
        self.user = User.main
        self.payoffItemQueue = makeInitialPayoffItemQueueStr()
        self.expiration = .endOfDay(startTime)
        self.dateCreated = .now
    }
}



public extension TodayShift {
    func addTemporaryAllocation(_ tempAlloc: TemporaryAllocation) throws {
        guard let newItemUUIDStr = tempAlloc.id?.uuidString
        else {
            return
        }

        var newPayoffItemQueue = getPayoffItemQueue()
        newPayoffItemQueue.append(newItemUUIDStr)

        payoffItemQueue = newPayoffItemQueue.joinString(",")

        addToTemporaryAllocations(tempAlloc)

        try managedObjectContext?.save()
    }

    
    func makeInitialPayoffItemQueueStr() -> String? {
        
        let unfinishedExpenses = User.main.getExpenses().filter { $0.amountRemainingToPayOff > 0 }
        let unfinishedGoals = User.main.getGoals().filter { $0.amountRemainingToPayOff > 0 }
        let both = (unfinishedGoals + unfinishedGoals).sorted { $0.dateCreated ?? .distantFuture < $1.dateCreated ?? .distantFuture }
        
        
        return both.map { $0.id?.uuidString }.joinString(",")
    }

    func getPayoffItemQueue() -> [String] {
        guard let payoffItemQueue else { return [] }
        return payoffItemQueue.components(separatedBy: ",")
    }

    func deleteTemporaryAllocation(_ temporaryAllocation: TemporaryAllocation) throws {
        guard var temporaryAllocations = temporaryAllocations as? Set<TemporaryAllocation> else {
            throw NSError(domain: "Could not locate Temporary Allocations for TodayShift \(self)", code: 99)
        }
        temporaryAllocations.remove(temporaryAllocation)

        if let id = temporaryAllocation.id?.uuidString {
            var payoffItems = getPayoffItemQueue()
            payoffItems.removeAll(of: id)

            payoffItemQueue = payoffItems.joinString(",")
        }

        try managedObjectContext?.save()
    }

    // Function to rearrange payoffItemQueueStr
    func rearrangePayoffItemQueue(from source: IndexSet, to destination: Int) throws {
        guard let payoffItemQueueStr = payoffItemQueue else {
            return
        }
        var payoffItemQueueArray = payoffItemQueueStr.components(separatedBy: ",")
        payoffItemQueueArray.move(fromOffsets: source, toOffset: destination)
        payoffItemQueue = payoffItemQueueArray.joined(separator: ",")
        
        try managedObjectContext?.save()
        
    }
}

// MARK: - Calculations

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
