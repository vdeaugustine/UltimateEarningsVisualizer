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
    // Main function
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
    
    func templateForPreview() -> some View {
        ZStack {
            Color.listBackgroundColor
            self
        }
        .ignoresSafeArea()
    }

    // View modifiers
    func rectContainer(shadowRadius: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        modifier(RectContainerModifier(shadowRadius: shadowRadius, cornerRadius: cornerRadius))
    }

    func bottomButton(label: String, gradient: LinearGradient? = nil, padding: CGFloat = 50, action: @escaping () -> Void) -> some View {
        modifier(BottomButtonModifier(label: label, gradient: gradient, padding: padding, action: action))
    }

    func bottomNavigation<Destination: View>(label: String,
                                             gradient: LinearGradient? = nil,
                                             padding: CGFloat = 10,
                                             @ViewBuilder destination: @escaping () -> Destination)
        -> some View {
        modifier(BottomNavigationModifier(label: label, gradient: gradient, padding: padding, destination: destination))
    }

    func bottomCapsule(label: String,
                       gradient: LinearGradient = User.main.getSettings().getDefaultGradient(),
                       bool: Bool = true, bottomPadding: CGFloat = 0,
                       action: @escaping () -> Void)
        -> some View {
        modifier(BottomCapsuleModifier(label: label, gradient: gradient, bool: bool, bottomPadding: bottomPadding, action: action))
    }

    func conditionalModifier<T: View>(_ condition: Bool, _ modifier: @escaping (Self) -> T) -> some View {
        Group {
            if condition {
                modifier(self)
            } else {
                self
            }
        }
    }

    // Home section views
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

    func background(_ color: Color, cornerRadius: CGFloat, shadow: CGFloat = 1, padding: CGFloat = 5) -> some View {
        self.padding(padding)
            .background(RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(color)
            .shadow(radius: shadow))
    }
}

// MARK: - BottomButtonView

struct BottomButtonView: View {
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
    let padding: CGFloat
    let action: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(.bottom, padding)
            VStack {
                Spacer()
                Button(action: action) {
                    BottomButtonView(label: label, gradient: gradient)
                }
            }
        }
    }
}

// MARK: - BottomNavigationModifier

struct BottomNavigationModifier<Destination: View>: ViewModifier {
    let label: String
    let gradient: LinearGradient?
    let padding: CGFloat
    @ViewBuilder let destination: () -> Destination

    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(.bottom, padding)
            VStack {
                Spacer()
                NavigationLink {
                    destination()
                } label: {
                    BottomButtonView(label: label, gradient: gradient)
                }
            }
        }
    }
}

// MARK: - BottomCapsuleModifier

struct BottomCapsuleModifier: ViewModifier {
    let label: String
    let gradient: LinearGradient
    let bool: Bool
    let bottomPadding: CGFloat
    let action: () -> Void

    func body(content: Content) -> some View {
        if bool {
            content
                .overlay(
                    bottomCapsuleOverlay(label: label, gradient: gradient)
                        .onTapGesture {
                            action()
                        }
                        .padding(bottomPadding)
                )
        } else {
            content
        }
    }

    private func bottomCapsuleOverlay(label: String, gradient: LinearGradient) -> some View {
        VStack {
            Spacer()
                .safeAreaInset(edge: .bottom) {
                    ZStack {
                        Capsule()
                            .fill(gradient)
                        Text(label)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 135, height: 50)
                }
        }
    }
}
