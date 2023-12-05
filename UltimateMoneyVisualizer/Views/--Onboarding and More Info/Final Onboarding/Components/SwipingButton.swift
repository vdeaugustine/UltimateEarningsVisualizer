//
//  SwipingButton.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI

// MARK: - SwipingButton

struct SwipingButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(.headline, design: .rounded, weight: .medium)
                .foregroundStyle(.white)
                .padding()
                .padding(.horizontal)
                .background {
                    Color.accentColor
                }
                .clipShape(Capsule(style: .circular))
        }
    }
}

#Preview {
    SwipingButton(label: "testing") {}
}
