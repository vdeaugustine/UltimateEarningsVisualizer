//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

extension Settings {
    var themeColor: Color {
        get {
            if let str = themeColorStr {
                return .hexStringToColor(hex: str)
            }

            return .defaultColorOptions.first!
        }

        set {
            let str = newValue.getHex()
            themeColorStr = str
            objectWillChange.send()
            do {
                try PersistenceController.context.save()
            } catch {
                print(error)
            }
        }
    }

    func getDefaultGradient(_ addValue: CGFloat? = nil) -> LinearGradient {
        LinearGradient(stops: [.init(color: themeColor,
                                     location: 0),
                               .init(color: themeColor.getLighterColorForGradient(addValue ?? 50),
                                     location: 1)],
                       startPoint: .bottom,
                       endPoint: .topLeading)
    }
}
