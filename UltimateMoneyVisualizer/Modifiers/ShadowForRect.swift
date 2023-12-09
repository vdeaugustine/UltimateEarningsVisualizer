//
//  ShadowForRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import Foundation
import SwiftUI

// MARK: - ShadowForRect

struct ShadowForRect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(UIColor.systemBackground.color)
            .clipShape(RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
    }
}
