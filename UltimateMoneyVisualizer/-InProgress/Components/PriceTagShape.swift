//
//  PriceTagShape.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/24/23.
//

import SwiftUI

// MARK: - PriceTagShape

struct PriceTagShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // The radius of the hexagon is half the height of the rectangle
        let hexagonRadius = rect.height * 0.35

        // The center of the hexagon is calculated based on the trigonometric calculations
        let hexagonCenter = CGPoint(x: rect.maxX - hexagonRadius * cos(.pi / 6), y: rect.midY)

        // Start drawing the path from the bottom-left corner of the rectangle
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))

        // Draw a line to the beginning of the hexagon (top left corner of the hexagon)
        path.addLine(to: CGPoint(x: hexagonCenter.x, y: rect.minY))

        // Draw the top side of the hexagon
        path.addLine(to: CGPoint(x: hexagonCenter.x + hexagonRadius * cos(.pi / 6), y: hexagonCenter.y - hexagonRadius * sin(.pi / 6)))

        // Draw the bottom side of the hexagon
        path.addLine(to: CGPoint(x: hexagonCenter.x + hexagonRadius * cos(.pi / 6), y: hexagonCenter.y + hexagonRadius * sin(.pi / 6)))

        // Draw a line to the end of the rectangle (bottom right corner of the hexagon)
        path.addLine(to: CGPoint(x: hexagonCenter.x, y: rect.maxY))

        // Draw a line back to the starting point to complete the rectangle
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        // Close the path
        path.closeSubpath()

        return path
    }
}

struct PriceTag: View {
    var width: CGFloat = 200
    var height: CGFloat = 100
    var color: Color = .blue
    var holePunchColor: Color = .white
    var body: some View {
        ZStack(alignment: .trailing) {
            PriceTagShape()
                .foregroundColor(color)
            HStack {
                Circle()
                    .foregroundColor(holePunchColor)
                    .frame(height: height / 10 )
            }
            .padding(.trailing, 5)
        }
    }
}

// MARK: - PriceTagShape_Previews

struct PriceTagShape_Previews: PreviewProvider {
    static var previews: some View {
        PriceTag()
            .frame(width: 200, height: 100)
    }
}
