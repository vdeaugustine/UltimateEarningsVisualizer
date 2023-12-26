//
//  BoxGroup.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/16/23.
//

import SwiftUI

// MARK: - BoxGroupStyle

struct BoxGroupStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        GroupBox(label: configuration.label) {
            configuration.content
        }
        .background(UIColor.secondarySystemBackground.color)
    }
}

// MARK: - ColorSchemeDependent

struct ColorSchemeDependent: GroupBoxStyle {
    var colorScheme: ColorScheme

    var color: Color {
        colorScheme == .dark ? UIColor.tertiarySystemBackground.color :
            UIColor.systemBackground.color
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            configuration.label
                .background {
                    UIColor.secondarySystemBackground.color
                }
            configuration.content
                .background {
                    UIColor.secondarySystemBackground.color
                }
        }
        .padding(10, 10)
        .background {
            UIColor.secondarySystemBackground.color
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

extension View {
    func colorSchemeDependentGroupBoxStyle() -> some View {
        let colorScheme = Environment(\.colorScheme).wrappedValue
        return groupBoxStyle(ColorSchemeDependent(colorScheme: colorScheme))
    }
}

// MARK: - BackgroundColorModifier

struct BackgroundColorModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var maxWidth: Bool = true
    var maxHeight: Bool = true
    var ignoresSafeArea: Bool = true

    var color: Color {
        colorScheme == .dark ? UIColor.tertiarySystemBackground.color : UIColor.secondarySystemBackground.color
    }

    func body(content: Content) -> some View {
        content
            .background {
                Color.secondaryBackground
                    .conditionalModifier(maxWidth) { view in
                        view.frame(maxWidth: .infinity)
                    }
                    .conditionalModifier(maxHeight) { view in
                        view.frame(maxHeight: .infinity)
                    }
                    .conditionalModifier(ignoresSafeArea) { view in
                        view.ignoresSafeArea()
                    }
            }
            .background()
    }
}

extension View {
    func backgroundColorForMode(maxWidth: Bool = true,
                                maxHeight: Bool = true,
                                ignoresSafeArea: Bool = true)
        -> some View {
        modifier(
            BackgroundColorModifier(maxWidth: maxWidth,
                                    maxHeight: maxHeight,
                                    ignoresSafeArea: ignoresSafeArea)
        )
    }
}

extension GroupBoxStyle {
    static var boxGroup: BoxGroupStyle {
        BoxGroupStyle()
    }
}
