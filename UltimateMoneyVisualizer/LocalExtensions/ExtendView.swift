//
//  ExtendView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import Foundation
import SwiftUI
import Vin

extension View {
    func putInTemplate() -> some View {
        navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(LinearGradient(stops: [.init(color: User.main.getSettings().themeColor,
                                                            location: 0),
                                                      .init(color: User.main.getSettings().themeColor.getLighterColorForGradient(90),
                                                            location: 1)],
                                              startPoint: .leading,
                                              endPoint: .trailing),
                               for: .navigationBar)
            .toolbarBackground(.visible, for: .tabBar)
            .accentColor(User.main.getSettings().themeColor)
            .tint(User.main.getSettings().themeColor)
    }

    func rectContainer(shadowRadius: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        modifier(RectContainerModifier(shadowRadius: shadowRadius, cornerRadius: cornerRadius))
    }

    func homeSection<Content: View>(rectContainer: Bool = true,
                                    header: String,
                                    @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(header)
                .font(.headline)
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }

    func homeSection<Nav: View, Content: View>(rectContainer: Bool = true,
                                               @ViewBuilder header: @escaping () -> Nav,
                                               @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            header()
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }

    func bottomButton(label: String, gradient: LinearGradient? = nil, action: @escaping () -> Void) -> some View {
        modifier(BottomButtonModifier(label: label, gradient: gradient, action: action))
    }
}

// MARK: - BottomViewButton

struct BottomViewButton: View {
    let label: String
    var gradient: LinearGradient? = nil
    var brightnessConstant: CGFloat? = nil

    var buttonHeight: CGFloat = 50

    var body: some View {
        ZStack {
            gradient ?? User.main.getSettings().getDefaultGradient()
            Text(label)
                .font(.title3)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: buttonHeight)
    }
}

// MARK: - BottomButtonModifier

struct BottomButtonModifier: ViewModifier {
    let label: String
    let gradient: LinearGradient?
    let action: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                Button(action: action) {
                    BottomViewButton(label: label, gradient: gradient)
                }
            }
        }
    }
}

func bottomViewButton(label: String, gradient: LinearGradient? = nil, brightnessConstant: CGFloat? = nil, buttonHeight: CGFloat = 50) -> some View {
    ZStack {
        gradient ?? User.main.getSettings().getDefaultGradient()
        Text(label)
            .font(.title3)
            .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity)
    .frame(height: buttonHeight)
}
