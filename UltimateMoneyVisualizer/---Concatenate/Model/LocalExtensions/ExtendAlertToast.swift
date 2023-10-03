//
//  ExtendAlertToast.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/9/23.
//

import Foundation
import AlertToast
import SwiftUI


extension AlertToast {
    
    static func errorWith(message: String) -> AlertToast {
        .init(displayMode: .alert, type: .error(User.main.getSettings().themeColor), title: message)
    }
    
    static func successWith(message: String) -> AlertToast {
        .init(displayMode: .alert, type: .complete(User.main.getSettings().themeColor), title: message)
    }
}
