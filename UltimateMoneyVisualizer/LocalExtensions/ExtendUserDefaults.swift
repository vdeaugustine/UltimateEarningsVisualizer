//
//  ExtendUserDefaults.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import Foundation
import SwiftUI
import Vin


extension Color {
    func getLighterColorForGradient(_ increaseAmount: CGFloat? = nil) -> Color {
        var b = components.blue * 255
        var r = components.red * 255
        var g = components.green * 255

        b += increaseAmount ?? 40
        r += increaseAmount ?? 40
        g += increaseAmount ?? 40

        if b > 255 { b = 255 }
        if r > 255 { r = 255 }
        if g > 255 { g = 255 }

        return Color(uiColor: .init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1))
    }
}
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
