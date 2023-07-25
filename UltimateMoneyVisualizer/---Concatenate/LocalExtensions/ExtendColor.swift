//
//  ExtendColor.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import Foundation
import SwiftUI
import Vin

extension Color {
    static let overcastColors: [String] = ["003649",
                                           "EA445A",
                                           "EA4E3D",
                                           "F09A37",
                                           "F7CE45",
                                           "9D8563",
                                           "65C466",
                                           "59C3BD",
                                           "5AADC4",
                                           "3377F5",
                                           "5856CE",
                                           "A358D6"]

    static let defaultColorHexes: [String] = ["#003649", "#004C64", "#006D8E", "#008CB4", "#00A1D8", "#00C7FC", "#51D6FC", "#73A7FF", "#3987FE", "#0061FE", "#0056D6", "#0042A9", "#002F7B", "#001C56", "#10053B", "#1A0A52", "#2C0976", "#361A94", "#4C22B2", "#5D30EB", "#854EFE", "#D356FE", "#BE38F3", "#982ABC", "#79219E", "#60187B", "#440D59", "#2D063C", "#3B071A", "#541028", "#791A3D", "#99234E", "#B92D5C", "#E63B79", "#FE624F", "#FF4014", "#E22400", "#B51A00", "#831100", "#5C0700", "#591C00", "#7B2900", "#AD3E00", "#DA5100", "#FF6A00", "#FE8647", "#FFA57C", "#FFC776", "#FEB43E", "#FEAB00", "#D38300", "#A96800", "#7A4900", "#583200", "#553D00", "#775700", "#A67B01", "#D19D00", "#FDC700", "#FECB3D"]

    static let defaultColorOptions: [Color] = overcastColors.map { .hexStringToColor(hex: $0) }
    
    static let manyColorsOptions: [Color] = defaultColorHexes.map { .hexStringToColor(hex: $0) }

    static let niceRed: Color = .hexStringToColor(hex: "B04632")
    static let okGreen: Color = .hexStringToColor(hex: "519839")

    func getHex() -> String {
        let components = self.components
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    static let targetGray: Color = .hexStringToColor(hex: "F6F6F7")
    
    static let googleBlueLabelBackground = Color(hex: "E8F0FE")
    static let googleBlueLabelText = Color(hex: "2867D2")
}
