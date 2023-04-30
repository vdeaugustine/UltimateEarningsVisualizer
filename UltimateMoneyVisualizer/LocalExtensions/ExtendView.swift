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
    
    
    
    
    
    
}
