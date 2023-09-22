//
//  SubscriptionManager.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/24/23.
//

import Foundation

class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    private var isPremiumUser: Bool = false

    init() {
        self.isPremiumUser = checkPremiumStatus()
    }

    // Call this function to check the subscription status
    func checkPremiumStatus() -> Bool {
        // Call to your server, or Apple's servers to check the subscription status
        // You will typically want to cache the result to avoid frequent network calls
        // For simplicity, we're returning a constant value here
        
        let answer = false
        
        isPremiumUser = answer
        return answer
    }

    // Use this function to guard premium features
    func canAccessPremiumFeatures() -> Bool {
        return isPremiumUser
    }
}
