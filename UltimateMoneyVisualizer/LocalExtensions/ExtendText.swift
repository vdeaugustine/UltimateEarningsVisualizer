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
    
    
    func format(size: CGFloat, weight: Font.Weight = .regular, color: Color = .primary) -> Text {
        self.font(.system(size: size)).fontWeight(weight).foregroundColor(color)
    }
    
    
    
    
}

extension Font {
    static let robotoRegular: String = "Roboto-Regular"
    
    
}
