//
//  TempTodayPayoff.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import Foundation

// MARK: - TempTodayPayoff

public struct TempTodayPayoff: Identifiable, Equatable {
    var amount: Double
    let initialAmountPaidOff: Double
    var amountPaidOff: Double
    var amountRemaining: Double { amount - amountPaidOff }
    var progressAmount: Double { amountPaidOff - initialAmountPaidOff }
    var title: String
    public let id: UUID
    let type: PayoffType
    var queueSlotNumber: Int?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.amountPaidOff == rhs.amountPaidOff
    }

    init(expense: Expense, queueSlotNumber: Int) {
        self.amount = expense.amount
        self.amountPaidOff = expense.amountPaidOff
        self.initialAmountPaidOff = expense.amountPaidOff
        self.title = expense.titleStr
        self.id = expense.getID()
        self.type = .expense
        self.queueSlotNumber = queueSlotNumber
    }

    init(goal: Goal, queueSlotNumber: Int) {
        self.amount = goal.amount
        self.amountPaidOff = goal.amountPaidOff
        self.initialAmountPaidOff = goal.amountPaidOff
        self.title = goal.titleStr
        self.id = goal.getID()
        self.type = .goal
        self.queueSlotNumber = queueSlotNumber
    }

    init(amount: Double, amountPaidOff: Double, title: String, type: PayoffType, id: UUID, queueSlotNumber: Int) {
        self.amount = amount
        self.amountPaidOff = amountPaidOff
        self.initialAmountPaidOff = amountPaidOff
        self.id = id
        self.title = title
        self.type = type
        self.queueSlotNumber = queueSlotNumber
    }

    init(payoff: PayoffItem, queueSlotNumber: Int) {
        self.amount = payoff.amount
        self.amountPaidOff = payoff.amountPaidOff
        self.initialAmountPaidOff = payoff.amountPaidOff
        self.title = payoff.titleStr
        self.id = payoff.getID()
        self.type = .init(payoff)
        self.queueSlotNumber = queueSlotNumber
    }
    
    
    func getPayoffItem(user: User) -> PayoffItem {
        if let goal = user.getGoals().first(where: { $0.id == self.id }) {
            return goal
        }
        
        if let expense = user.getExpenses().first(where: { $0.id == self.id }) {
            return expense
        }
        
        fatalError("Error getting payoff item for temp payoff \(self)")
    }
    
    
    
    
}

// Function to pay off given items from a total amount available, returning a modified array of payoff items
func payOfPayoffItems(with amount: Double, payoffItems: [TempTodayPayoff]) -> [TempTodayPayoff] {
    // Initialize an empty array to store the modified payoff items
    var newTemporaryPayoffItems: [TempTodayPayoff] = []
    
    // Store the remaining amount available for payment
    var remainingAmountAvailableToUseForPayment = amount

    // Iterate through each item in the given payoff items
    for item in payoffItems {
        // Make a mutable copy of the current item to work with
        var thisItem = item

        // Calculate the amount to be paid off for this item, which is the lesser of the remaining amount or the amount remaining in the item
        let amountToPayOff = min(remainingAmountAvailableToUseForPayment, item.amountRemaining)
        
        // Increment the amount paid off for this item by the calculated amount
        thisItem.amountPaidOff += amountToPayOff
        
        // Decrease the remaining amount available to use for payment by the amount paid off
        remainingAmountAvailableToUseForPayment -= amountToPayOff
        
        // Append the modified item to the new array
        newTemporaryPayoffItems.append(thisItem)

        // Check if there's no remaining amount available for payment, then exit the loop if so
        if remainingAmountAvailableToUseForPayment <= 0 {
            // Check if there's a difference in count between the original and new arrays
            let countDifference = payoffItems.count - newTemporaryPayoffItems.count
            if countDifference != 0 {
                // If there's a difference, append the remaining items from the original array to the new array
                newTemporaryPayoffItems += payoffItems.suffixArray(countDifference)
            }
            break
        }
    }

    // Return the new array with modified payoff items
    return newTemporaryPayoffItems
}


