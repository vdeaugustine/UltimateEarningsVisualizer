//
//  SystemImageWithFilledBackground.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import SwiftUI

struct SystemImageWithFilledBackground: View {
    let systemName: String
    let backgroundColor: Color?
    var rotationDegrees: CGFloat = 0
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
                .font(.headline)
                .foregroundColor(.white)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .frame(width: 28, height: 28)
        .cornerRadius(8)
    }
}

// MARK: - SystemImageWithFilledBackground_Previews

struct SystemImageWithFilledBackground_Previews: PreviewProvider {
    static var previews: some View {
        SystemImageWithFilledBackground(systemName: "calendar", backgroundColor: .blue)
    }
}
