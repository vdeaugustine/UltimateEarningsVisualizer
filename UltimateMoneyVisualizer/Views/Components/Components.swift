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
}
