//
//  FigmaDesign.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/13/23.
//

import SwiftUI

// MARK: - FigmaDesign

struct FigmaDesign: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 144, height: 101)
                .background(
                    LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.15,
                                                                      green: 0.15,
                                                                      blue: 0.15),
                                                         location: 0.00),
                                           Gradient.Stop(color: Color(red: 0.16,
                                                                      green: 0.16,
                                                                      blue: 0.16),
                                                         location: 0.69),
                                           Gradient.Stop(color: Color(red: 0.25,
                                                                      green: 0.25,
                                                                      blue: 0.25),
                                                         location: 1.00)],
                                   startPoint: UnitPoint(x: -0.37, y: -0.24),
                                   endPoint: UnitPoint(x: 2.66, y: 2.06))
                )
                .cornerRadius(18)

            VStack {
                Text("Earned")
                    .font(
                        Font.custom("Avenir", size: 12)
                            .weight(.medium)
                    )
                    .foregroundColor(.white)

                Text("$124")
                    .font(Font.custom("Avenir", size: 22))
                    .foregroundColor(.white)

                Text("Dollars")
                    .font(Font.custom("Avenir", size: 10))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 430, height: 932)
        .background(
            LinearGradient(stops: [Gradient.Stop(color: Color(red: 0.02,
                                                              green: 0.05,
                                                              blue: 0.13),
                                                 location: 0.00),
                                   Gradient.Stop(color: Color(red: 0.01,
                                                              green: 0.02,
                                                              blue: 0.05),
                                                 location: 0.35),
                                   Gradient.Stop(color: Color(red: 0.01,
                                                              green: 0.01,
                                                              blue: 0.03),
                                                 location: 0.48),
                                   Gradient.Stop(color: Color(red: 0,
                                                              green: 0.01,
                                                              blue: 0.02),
                                                 location: 0.58),
                                   Gradient.Stop(color: Color(red: 0,
                                                              green: 0.01,
                                                              blue: 0.01),
                                                 location: 0.69),
                                   Gradient.Stop(color: Color(red: 0,
                                                              green: 0,
                                                              blue: 0.01),
                                                 location: 0.79),
                                   Gradient.Stop(
                                       color: .black,
                                       location: 0.93
                                   )],
                           startPoint: UnitPoint(x: 0.5, y: -0.34),
                           endPoint: UnitPoint(x: 0.5, y: 1))
        )
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

// MARK: - FigmaDesign_Previews

struct FigmaDesign_Previews: PreviewProvider {
    static var previews: some View {
        FigmaDesign()
    }
}
