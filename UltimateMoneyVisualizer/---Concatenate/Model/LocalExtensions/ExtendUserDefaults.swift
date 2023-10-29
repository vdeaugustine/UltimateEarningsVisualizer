//
//  ExtendUserDefaults.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import Foundation
import SwiftUI
import Vin



extension UserDefaults {
    
    static func getDefaultGradient(_ addValue: CGFloat? = nil) -> LinearGradient {
        LinearGradient(stops: [.init(color: themeColor,
                                     location: 0),
                               .init(color: themeColor.getLighterColorForGradient(addValue ?? 50),
                                     location: 1)],
                       startPoint: .bottom,
                       endPoint: .topLeading)
    }
    
    static var themeColorStr: String {
        get {
            UserDefaults.standard.string(forKey: "themeColorStr") ?? Color.defaultColorHexes.first!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "themeColorStr")
        }
    }

    static var themeColor: Color {
        get {
            Color(hex: themeColorStr)
        }

        set {
            themeColorStr = newValue.getHex()
        }
    }
    
    static var appOpenAmount: Int {
        get {
            UserDefaults.standard.integer(forKey: "appOpenAmount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appOpenAmount")
        }
    }
}
