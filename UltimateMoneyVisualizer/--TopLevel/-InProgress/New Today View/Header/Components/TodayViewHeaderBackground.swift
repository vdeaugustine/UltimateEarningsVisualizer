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


struct TodayViewHeaderBackground: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(Color(hex: "003DFF"))
            FirstVector()
                .frame(height: 195)
                .foregroundStyle(Color(hex: "2A50FE"))
            SecondVector()
                .frame(height: 90)
                .foregroundStyle(Color(hex: "3060FE"))
        }

        .frame(height: 237)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - TodayViewHeader_Previews

struct TodayViewHeaderBackground_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewHeaderBackground()
    }
}


