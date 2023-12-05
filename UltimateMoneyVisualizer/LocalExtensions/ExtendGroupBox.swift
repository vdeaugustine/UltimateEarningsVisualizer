//
//  ExtendGroupBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import Foundation
import SwiftUI

// MARK: - ShadowBoxGroupBoxStyle

public struct ShadowBoxGroupBoxStyle: GroupBoxStyle {
    var radius: CGFloat = 5
    var x: CGFloat = 0
    var y: CGFloat = 2
    var headerContentSpacing: CGFloat = 15
    var paddingInsets: EdgeInsets? = nil
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: headerContentSpacing) {
            configuration.label
                .fontWeight(.semibold)
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .conditionalModifier(paddingInsets == nil) { view in
            view.padding()
        }
        .conditionalModifier(paddingInsets != nil) { view in
            view.padding(paddingInsets!)
        }
        // Add padding around the content
        .background(Color.white) // Set the background color to white
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: radius, x: x, y: y) // Adds shadow
    }
}

// MARK: - OutlineBoxGroupBoxStyle

public struct OutlineBoxGroupBoxStyle: GroupBoxStyle {
    var color: Color = .secondary
    var lineWidth: CGFloat = 1
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            configuration.label
                .fontWeight(.semibold)
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .padding() // Add padding around the content
        .background(Color.white) // Set the background color to white
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: lineWidth)
        }
    }
}
