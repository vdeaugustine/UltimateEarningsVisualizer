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
            .toolbarBackground(LinearGradient(stops: [.init(color: .hexStringToColor(hex: UserDefaults.themeColorStr),
                                                            location: 0),
                                                      .init(color: UserDefaults.themeColor.getLighterColorForGradient(90),
                                                            location: 1)],
                                              startPoint: .leading,
                                              endPoint: .trailing),
                               for: .navigationBar)
            .toolbarBackground(.visible, for: .tabBar)
            .accentColor(UserDefaults.themeColor)
            .tint(UserDefaults.themeColor)
    }
}
