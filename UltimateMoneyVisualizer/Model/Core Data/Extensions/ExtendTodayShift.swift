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
    @discardableResult convenience init(startTime: Date, endTime: Date, user: User, context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)

        self.user = user
        self.payoffItemQueue = makeInitialPayoffItemQueueStr()
        self.expiration = .endOfDay(startTime)
        self.dateCreated = .now
        self.startTime = startTime
        self.endTime = endTime
        
        user.updateTempQueue()
        
        try context.save()
    }

    static func makeExampleTodayShift(user: User, context: NSManagedObjectContext) throws {
        let todayShift = try TodayShift(startTime: .nineAM, endTime: .fivePM, user: user, context: context)

        // Get the list of expenses that still have remaining amounts to be paid off.
        var expensesNotFinished: [Expense] {
            user.getExpenses().filter { $0.amountRemainingToPayOff > 0 }
        }

        // Get the list of goals that still have remaining amounts to be paid off.
        var goalsNotFinished: [Goal] {
            user.getGoals().filter { $0.amountRemainingToPayOff > 0 }
        }

        var amountRemaining = todayShift.totalEarnedSoFar(.now)

        while amountRemaining > 0 {
            let combined: [Any] = goalsNotFinished + expensesNotFinished

            guard let chosen = combined.randomElement() else {
                return
            }

            if let expense = chosen as? Expense {
                let amount = Double.random(in: 0 ... min(amountRemaining, expense.amountRemainingToPayOff))
                let temp = try TemporaryAllocation(initialAmount: amount, expense: expense, goal: nil, context: context)
                try todayShift.addTemporaryAllocation(temp, context: context)
                amountRemaining -= amount
            }

            if let goal = chosen as? Goal {
                let amount = Double.random(in: 0 ... min(amountRemaining, goal.amountRemainingToPayOff))
                let temp = try TemporaryAllocation(initialAmount: amount, expense: nil, goal: goal, context: context)
                try todayShift.addTemporaryAllocation(temp, context: context)
                amountRemaining -= amount
            }
        }

        try context.save()
    }
}

public extension TodayShift {
    func addTemporaryAllocation(_ tempAlloc: TemporaryAllocation, context: NSManagedObjectContext) throws {
        guard let newItemUUIDStr = tempAlloc.id?.uuidString
        else {
            return
        }

        var newPayoffItemQueue = getPayoffItemQueue()
        newPayoffItemQueue.append(newItemUUIDStr)

        payoffItemQueue = newPayoffItemQueue.joinString(",")

        addToTemporaryAllocations(tempAlloc)

        try context.save()
    }

    func makeInitialPayoffItemQueueStr() -> String? {
        let unfinishedExpenses = User.main.getExpenses().filter { $0.amountRemainingToPayOff > 0 }
        let unfinishedGoals = User.main.getGoals().filter { $0.amountRemainingToPayOff > 0 }
        let both: [PayoffItem] = (unfinishedGoals + unfinishedExpenses)
        let sorted = both.sorted { ($0.dateCreated ?? .distantFuture) < ($1.dateCreated ?? .distantFuture) }

        return sorted.map { $0.getID().uuidString }.joinString(",")
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
    func getTemporaryAllocations() -> [TemporaryAllocation] {
        guard let allocs = Array(temporaryAllocations ?? []) as? [TemporaryAllocation]
        else {
            return []
        }
        return allocs
    }

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
