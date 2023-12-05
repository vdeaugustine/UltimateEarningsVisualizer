//
//  FinalOnboardingButton.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .regular))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.accentColor
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
    }
}

#Preview {
    FinalOnboardingButton(title: "Testing button") {
        print("Does action")
    }
}
