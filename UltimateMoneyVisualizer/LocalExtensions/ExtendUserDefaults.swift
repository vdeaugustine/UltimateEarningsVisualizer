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
            Color.hexStringToColor(hex: themeColorStr)
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
