//
//  Components.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import Foundation
import SwiftUI

struct Components {
    @ViewBuilder static var nextPageChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .foregroundColor(.hexStringToColor(hex: "BFBFBF"))
    }

    @ViewBuilder static func coloredBar(_ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 3)
            .padding(.vertical, 5)
    }

    static var taxesColor = Color.red
    static var expensesColor = Color.blue
    static var goalsColor = Color.green
    static var unspentColor = User.main.getSettings().themeColor
}
