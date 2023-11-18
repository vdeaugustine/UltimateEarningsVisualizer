//
//  ImageWithCircleForOnboarding.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI

// MARK: - ImageWithCircleForOnboarding

struct ImageWithCircleForOnboarding: View {
    let image: String
    let size: CGSize
    var body: some View {
        ZStack {
            Color.accentColor.brightness(0.20)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(30 * (size.height / 759))
        }
        .clipShape(Circle())
        .frame(width: 300 * (size.height / 759))
    }
}


#Preview {
    GeometryReader { geo in 
        ImageWithCircleForOnboarding(image: "moneyCalendar", size: geo.size)
    }
}
