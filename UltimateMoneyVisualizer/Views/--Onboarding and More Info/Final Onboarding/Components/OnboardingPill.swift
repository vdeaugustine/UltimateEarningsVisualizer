//
//  OnboardingPill.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI


// MARK: - ProgressPill

struct OnboardingPill: View {
    let isFilled: Bool
    var height: CGFloat = 7
    
    @ObservedObject private var settings = User.main.getSettings()
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(isFilled ? settings.themeColor : Color.secondary, lineWidth: 2)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(isFilled ? settings.themeColor : Color.clear)
    }
}


#Preview {
    OnboardingPill(isFilled: true)
}
