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
}
