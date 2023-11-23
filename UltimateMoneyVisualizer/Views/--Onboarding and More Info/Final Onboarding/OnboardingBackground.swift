//
//  OnboardingBackground.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/21/23.
//

import SwiftUI

struct OnboardingBackground: View {
    var body: some View {
        GeometryReader { _ in

            VStack {
                Image("snow")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
//                Spacer()
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Color.clear
                    .overlay(.ultraThinMaterial)
                    .opacity(0.5)
                    .blur(radius: 2)
            }
            
            
//            .overlay {
//                Color.white
//                    .opacity(0.5)
//                    .blur(radius: 1.3)
//            }

//            .overlay(.ultraThinMaterial)

//            ZStack {
//                let width = geo.size.width
//                let height = geo.size.height
//                let startX = CGFloat(0)
//                let startY = CGFloat(CGFloat(height / 4 + 20) * (height / 759))
//                let endY = startY
//                let start = CGPoint(x: startX, y: startY)
//                let end = CGPoint(x: width, y: endY)
//                let controlPoint = CGPoint(x: width / 2, y: endY + (130 * (height / 759)))
//
//                Path { path in
//                    path.move(to: start)
//                    path.addQuadCurve(to: end,
//                                      control: controlPoint)
//                    path.addLine(to: CGPoint(x: width, y: 0))
//                    path.addLine(to: .zero)
//                    path.closeSubpath()
//                }
//                .fill(.tint)
//                .ignoresSafeArea()
//
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Image("dollarNoBack")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxHeight: geo.size.height * 0.4)
//                    }
//                }
//                .padding(.leading)
//                .overlay(.ultraThinMaterial)
//            }
        }
    }
}

#Preview {
    OnboardingBackground()
}
