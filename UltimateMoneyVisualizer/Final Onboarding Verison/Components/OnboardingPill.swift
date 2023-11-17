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
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(isFilled ? .accentColor : Color.secondary, lineWidth: 2)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(isFilled ? Color.accentColor : Color.clear)
    }
}


#Preview {
    OnboardingPill(isFilled: true)
}
