//
//  PayoffItemDetailViewStyledButton.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import SwiftUI

struct PayoffItemDetailViewStyledButton<Av: Equatable>: View {
    let text: String
    var width: CGFloat = 120
    var height: CGFloat = 35
    let animationValue: Av
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .fontWeight(.semibold)
                .padding()
                .frame(width: width, height: height)
                .overlay {
                    Capsule(style: .circular).stroke(lineWidth: 3)
                }
                .animation(.none, value: animationValue)
        }
        .padding(.bottom, 5)
    }
}

struct PayoffItemDetailViewStyledButton_Previews: PreviewProvider {
    static var previews: some View {
        PayoffItemDetailViewStyledButton(text: "Hey", animationValue: false) {
            
        }
    }
}

