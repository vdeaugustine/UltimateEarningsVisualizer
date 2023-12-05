//
//  CircleBadgeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/3/23.
//

import SwiftUI

struct CircleBadgeView: View {
    @State var isEditing: Bool = true
    var isSelected: Bool = false
    let width: CGFloat
    var points: (x: CGFloat, y: CGFloat) {
        pointOnCircle(height: width, width: width, degrees: -45)
    }
    var isSelectedColor: Color {
        isSelected ? .red : .gray
    }

    var body: some View {
        ZStack {
            if isEditing {
                Image(systemName: "minus.circle.fill")
                    .symbolRenderingMode(.palette)
                    .resizable()
                    .frame(width: width / 2.75, height: width / 2.75)
                    .foregroundStyle(.white, isSelectedColor)
                    .position(x: points.x, y: points.y)
            }
        }
        .frame(width: width, height: width)
       
    }
    
    func pointOnCircle(height: CGFloat, width: CGFloat, degrees: CGFloat) -> (x: CGFloat, y: CGFloat) {
        // Calculate the radius of the circle
        let radius = min(height, width) / 2

        // Calculate the x and y coordinates of the point on the circle at -45 degrees
        let x = radius * cos(degrees * .pi / 180)
        let y = radius * sin(degrees * .pi / 180)

        // Return the x and y coordinates, adjusting for the center of the rectangle
        return (x + width / 2, y + height / 2)
    }
}

// MARK: - CircleBadgeView_Previews

struct CircleBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleBadgeView(isSelected: false, width: 100)
                .previewDisplayName("Not Selected")
            
            CircleBadgeView(isSelected: true, width: 100)
                .previewDisplayName("Selected")
            
            CircleBadgeView(isSelected: false, width: 150)
                .previewDisplayName("Not Selected - Large")
            
            CircleBadgeView(isSelected: true, width: 150)
                .previewDisplayName("Selected - Large")
        }
        .previewLayout(.sizeThatFits)
    }
}

