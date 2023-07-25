//
//  TestingChatGPTUI.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

// MARK: - UserProfileView

struct UserProfileView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    EllipticalGradient(stops: [Gradient.Stop(color: Color(red: 0.5,
                                                                          green: 0.5,
                                                                          blue: 0.5),
                                                             location: 0),
                                               Gradient.Stop(color: Color(red: 0.37,
                                                                          green: 0.37,
                                                                          blue: 0.37),
                                                             location: 0.63),
                                               Gradient.Stop(color: Color(red: 0.24,
                                                                          green: 0.24,
                                                                          blue: 0.24),
                                                             location: 1.5)],
                                       center: UnitPoint(x: -0.26, y: -0.18))
                )
                .blur(radius: 5)
                .frame(width: 150, height: 200)
                .clipShape(.rect(cornerRadius: 20))

            Text("Today View")
                .foregroundStyle(Color.white)
        }
        .frame(width: 393, height: 852)
        .background(
            EllipticalGradient(stops: [Gradient.Stop(color: Color(red: 0.05, green: 0.08, blue: 0.1), location: -10),
                                       Gradient.Stop(color: Color(red: 0.07, green: 0.11, blue: 0.14), location: 0.27),
                                       Gradient.Stop(color: Color(red: 0.09, green: 0.14, blue: 0.17), location: 0.75),
                                       Gradient.Stop(color: Color(red: 0.23, green: 0.38, blue: 0.45), location: 5)],
                               center: UnitPoint(x: 0.22, y: 0.36))
        )
    }
}

// MARK: - UserProfileView_Previews

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
