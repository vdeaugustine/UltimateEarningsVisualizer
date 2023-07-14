//
//  RedesignedPayoffRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/29/23.
//

import SwiftUI

// MARK: - RedesignedPayoffRow

struct RedesignedPayoffRow: View {
    var body: some View {
        ZStack {
            Color.hexStringToColor(hex: "86A57A")
            Image("dollar3d")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        }
        .frame(height: 150)
        .overlay {
            
        }
    }
}

// MARK: - RedesignedPayoffRow_Previews

struct RedesignedPayoffRow_Previews: PreviewProvider {
    static var previews: some View {
        RedesignedPayoffRow()
    }
}
