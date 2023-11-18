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
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding()
                .padding(.horizontal)
                .background {
                    settings.themeColor
                }
                .clipShape(Capsule(style: .circular))
        }
    }
}

#Preview {
    SwipingButton(label: "testing") {}
}
