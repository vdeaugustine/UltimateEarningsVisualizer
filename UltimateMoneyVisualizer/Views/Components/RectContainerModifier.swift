//
//  RectContainerModifier.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/30/23.
//

import SwiftUI

struct RectContainerModifier: ViewModifier {
    var shadowRadius: CGFloat = 1
    var cornerRadius: CGFloat = 8
   
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.white)
                .shadow(radius: shadowRadius)
            content
        }
        .frame(maxWidth: .infinity)
    }
}


struct RectContainerModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Something")
            .rectContainer(shadowRadius: 1, cornerRadius: 8)
    }
}
