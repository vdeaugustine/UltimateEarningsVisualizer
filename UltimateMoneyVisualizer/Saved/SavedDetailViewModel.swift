//
//  SavedDetailViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/22/23.
//

import AlertToast
import CoreData
import Foundation
import SwiftUI
import Vin

class SavedItemDetailViewModel: ObservableObject {
    // CATEGORY: Lifecycle

    init(savedItem: Saved) {
        self.savedItem = savedItem
    }
    
    @ObservedObject var user: User = User.main
    @ObservedObject var settings: Settings = User.main.getSettings()
    
    @Published var savedItem: Saved
    
    var totalAmount: Double {
        savedItem.amountForAllInstances(user: user)
    }
    

    // CATEGORY: Internal
}
