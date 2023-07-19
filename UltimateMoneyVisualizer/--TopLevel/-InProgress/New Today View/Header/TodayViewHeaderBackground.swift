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

// struct FirstVector: Shape {
//    func path(in rect: CGRect) -> Path {
//        let widthRatio = rect.width / 430
//        let heightRatio = rect.height / 195 // The height of the original design is 195
//
//        return Path { path in
//            path.move(to: CGPoint(x: 151.714 * widthRatio, y: 57.5 * heightRatio))
//            path.addCurve(to: CGPoint(x: rect.maxX, y: 189.5 * heightRatio),
//                          control1: CGPoint(x: 275.886 * widthRatio, y: 106.5 * heightRatio),
//                          control2: CGPoint(x: 287.556 * widthRatio, y: 33.5 * heightRatio))
//            path.addLine(to: CGPoint(x: 429 * widthRatio, y: 195 * heightRatio))
//            path.addLine(to: CGPoint(x: 0, y: 159 * heightRatio))
//            path.addLine(to: CGPoint(x: 0, y: 0))
//            path.addCurve(to: CGPoint(x: 151.714 * widthRatio, y: 57.5 * heightRatio),
//                          control1: CGPoint(x: 9.18063 * widthRatio, y: 2.83333 * heightRatio),
//                          control2: CGPoint(x: 52.3763 * widthRatio, y: 18.3 * heightRatio))
//            path.closeSubpath()
//        }
//    }
// }

// struct SecondVector: Shape {
//    func path(in rect: CGRect) -> Path {
//        let widthRatio = rect.width / 430
//        let heightRatio = rect.height / 90 // We know that the height of the original design is 90
//
//        return Path { path in
//            path.move(to: CGPoint(x: 0 * widthRatio, y: 13 * heightRatio))
//            path.addLine(to: CGPoint(x: 18 * widthRatio, y: 15 * heightRatio))
//            path.addCurve(to: CGPoint(x: 108 * widthRatio, y: 17 * heightRatio),
//                          control1: CGPoint(x: 36 * widthRatio, y: 17 * heightRatio),
//                          control2: CGPoint(x: 72 * widthRatio, y: 21 * heightRatio))
//            path.addCurve(to: CGPoint(x: 215 * widthRatio, y: 0 * heightRatio),
//                          control1: CGPoint(x: 143 * widthRatio, y: 13 * heightRatio),
//                          control2: CGPoint(x: 179 * widthRatio, y: 0 * heightRatio))
//            path.addCurve(to: CGPoint(x: 323 * widthRatio, y: 26 * heightRatio),
//                          control1: CGPoint(x: 251 * widthRatio, y: 0 * heightRatio),
//                          control2: CGPoint(x: 287 * widthRatio, y: 13 * heightRatio))
//            path.addCurve(to: CGPoint(x: 412 * widthRatio, y: 58 * heightRatio),
//                          control1: CGPoint(x: 358 * widthRatio, y: 38 * heightRatio),
//                          control2: CGPoint(x: 394 * widthRatio, y: 51 * heightRatio))
//            path.addLine(to: CGPoint(x: 430 * widthRatio, y: 64 * heightRatio))
//            path.addLine(to: CGPoint(x: 430 * widthRatio, y: 90 * heightRatio))
//            path.addLine(to: CGPoint(x: 0, y: 90 * heightRatio))
//            path.closeSubpath()
//        }
//    }
// }

struct TodayViewHeaderBackground: View {
    var body: some View {
//        GeometryReader { geo in
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(Color(hex: "003DFF"))
            FirstVector()
//                    .aspectRatio(contentMode: .fit)
                .frame(height: 195)
                .foregroundStyle(Color(hex: "2A50FE"))
            SecondVector()
//                    .aspectRatio(contentMode: .fit)
                .frame(height: 90)
                .foregroundStyle(Color(hex: "3060FE"))
        }

        .frame(height: 237)
        .frame(maxWidth: .infinity)
//            .aspectRatio(contentMode: .fit)
//            .onAppear(perform: {
//                print(geo.size)
//            })
//        }
    }
}

// MARK: - TodayViewHeader_Previews

struct TodayViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewHeaderBackground()
    }
}


