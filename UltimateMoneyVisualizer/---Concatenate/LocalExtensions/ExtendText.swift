//
//  ExtendText.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/11/23.
//

import Foundation
import SwiftUI

// MARK: - BoldNumber

// View modifier
struct BoldNumber: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .foregroundStyle(User.main.getSettings().getDefaultGradient())
    }
}

// Extension on Text
extension Text {
    func boldNumber() -> some View {
        modifier(BoldNumber())
    }
}
