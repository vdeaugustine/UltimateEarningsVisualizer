//
//  TodayViewHeader.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/18/23.
//

import SwiftUI

// MARK: - SecondVector

struct SecondVector: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 13))
            path.addLine(to: CGPoint(x: 18, y: 15))
            path.addCurve(to: CGPoint(x: 108, y: 17),
                          control1: CGPoint(x: 36, y: 17),
                          control2: CGPoint(x: 72, y: 21))
            path.addCurve(to: CGPoint(x: 215, y: 0),
                          control1: CGPoint(x: 143, y: 13),
                          control2: CGPoint(x: 179, y: 0))
            path.addCurve(to: CGPoint(x: 323, y: 26),
                          control1: CGPoint(x: 251, y: 0),
                          control2: CGPoint(x: 287, y: 13))
            path.addCurve(to: CGPoint(x: 412, y: 58),
                          control1: CGPoint(x: 358, y: 38),
                          control2: CGPoint(x: 394, y: 51))
            path.addLine(to: CGPoint(x: 430, y: 64))
            path.addLine(to: CGPoint(x: 430, y: 90))
            path.addLine(to: CGPoint(x: 0, y: 90))
            path.closeSubpath()
        }
    }
}

// MARK: - FirstVector

struct FirstVector: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 151.714, y: 57.5))
            path.addCurve(to: CGPoint(x: rect.maxX, y: 189.5),
                          control1: CGPoint(x: 275.886, y: 106.5),
                          control2: CGPoint(x: 287.556, y: 33.5))
            path.addLine(to: CGPoint(x: 429, y: 195))
            path.addLine(to: CGPoint(x: 0, y: 159))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addCurve(to: CGPoint(x: 151.714, y: 57.5),
                          control1: CGPoint(x: 9.18063, y: 2.83333),
                          control2: CGPoint(x: 52.3763, y: 18.3))
        }
    }
}

// MARK: - TodayViewHeaderBackground

struct TodayViewHeaderBackground: View {
    @ObservedObject private var settings = User.main.getSettings()
    var body: some View {
        ZStack(alignment: .bottom) {
            if let themeColorStr = settings.themeColorStr {
                Rectangle()
                    .foregroundStyle(Color(hex: themeColorStr))

                settings.themeColor.brightness(0.05)
                    .clipShape(FirstVector())
                    .frame(height: 195)

                settings.themeColor.brightness(0.1)
                    .clipShape(SecondVector())
                    .frame(height: 90)
            }
        }

        .frame(height: 190)
        .frame(maxWidth: .infinity)
    }

    func getNextTwoColors(from hexColor: String) -> (Color, Color) {
        guard let rgb = hexColor.toRGB() else { return (.white, .white) }

        let redDelta1 = 42.0, greenDelta1 = 19.0, blueDelta1 = -1.0
        let redDelta2 = 48.0, greenDelta2 = 35.0, blueDelta2 = -1.0

        let color1 = Color(red: Double(clamp(value: rgb.red + redDelta1, min: 0, max: 255)) / 255.0,
                           green: Double(clamp(value: rgb.green + greenDelta1, min: 0, max: 255)) / 255.0,
                           blue: Double(clamp(value: rgb.blue + blueDelta1, min: 0, max: 255)) / 255.0)

        let color2 = Color(red: Double(clamp(value: rgb.red + redDelta2, min: 0, max: 255)) / 255.0,
                           green: Double(clamp(value: rgb.green + greenDelta2, min: 0, max: 255)) / 255.0,
                           blue: Double(clamp(value: rgb.blue + blueDelta2, min: 0, max: 255)) / 255.0)

        return (color1, color2)
    }
}

extension String {
    func toRGB() -> (red: Double, green: Double, blue: Double)? {
        var hexSanitized = trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var hex: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&hex)

        let red = Double((hex & 0xFF0000) >> 16)
        let green = Double((hex & 0x00FF00) >> 8)
        let blue = Double(hex & 0x0000FF)

        return (red, green, blue)
    }
}

func clamp<T: Comparable>(value: T, min lower: T, max upper: T) -> T {
    return min(max(value, lower), upper)
}

// MARK: - TodayViewHeaderBackground_Previews

struct TodayViewHeaderBackground_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewHeaderBackground()
    }
}
