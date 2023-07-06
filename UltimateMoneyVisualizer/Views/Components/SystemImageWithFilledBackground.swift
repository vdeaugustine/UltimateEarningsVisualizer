//
//  SystemImageWithFilledBackground.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import SwiftUI

struct SystemImageWithFilledBackground: View {
    let systemName: String
    var backgroundColor: Color? = User.main.getSettings().themeColor
    var rotationDegrees: CGFloat = 0
    var width: CGFloat = 28
    var height: CGFloat = 28
    
    @ObservedObject var settings = User.main.getSettings()
    
    var body: some View {
        ZStack {
            if let backgroundColor {
                backgroundColor
            }
            else {
                settings.getDefaultGradient()
            }
            
            Image(systemName: systemName)
                .font(.system(size: 18 / 28 * height))
//                .font(.headline)
                .foregroundColor(.white)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .frame(width: width, height: height)
        .cornerRadius(8)
    }
}

// MARK: - SystemImageWithFilledBackground_Previews

struct SystemImageWithFilledBackground_Previews: PreviewProvider {
    static var previews: some View {
        SystemImageWithFilledBackground(systemName: "calendar", backgroundColor: .blue)
            .previewLayout(.sizeThatFits)
    }
}
