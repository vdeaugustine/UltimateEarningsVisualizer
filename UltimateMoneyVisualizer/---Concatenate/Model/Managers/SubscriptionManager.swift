//
//  SubscriptionManager.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/24/23.
//

import Foundation
import SwiftUI

class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    private var isPremiumUser: Bool = false
    private let goalsLimit: Int = 2
    private let expenseLimit: Int = 2
    private let savedLimit: Int = 2
    private let shiftLimit: Int = 2

    init() {
        self.isPremiumUser = checkPremiumStatus()
    }
    
    private func hasNotReachedGoalLimit() -> Bool {
        let goalsCount = User.main.getGoals().count
        return goalsCount < goalsLimit
    }
    
    func canCreateGoal() -> Bool {
        isPremiumUser || hasNotReachedGoalLimit()
    }

    // Call this function to check the subscription status
    func checkPremiumStatus() -> Bool {
        // Call to your server, or Apple's servers to check the subscription status
        // You will typically want to cache the result to avoid frequent network calls
        // For simplicity, we're returning a constant value here
        return false
    }

    // Use this function to guard premium features
    func canAccessPremiumFeatures() -> Bool {
        return isPremiumUser
    }
}


// MARK: - Settings Actions

extension SubscriptionManager {
    
    
    
    
    
}
