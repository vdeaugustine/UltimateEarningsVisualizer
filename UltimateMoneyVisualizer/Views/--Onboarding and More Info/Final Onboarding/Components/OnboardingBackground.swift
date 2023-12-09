//
//  OnboardingBackground.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/21/23.
//

import SwiftUI

struct OnboardingBackground: View {
    static let baseColor = /* Color(hex: "#006154") */ Color.white
    static let secondary = Color(hex: "#3DB6A6")
    static let tertiary = Color(hex: "#E0C970")

    static let colors = [baseColor, secondary, tertiary]

    let lGradient = LinearGradient(gradient: Gradient(colors: colors
    ), startPoint: .topLeading, endPoint: .bottomTrailing)

    let rGradient = RadialGradient(gradient: Gradient(colors: colors.reversed()),
                                   center: .trailing,
                                   startRadius: 100,
                                   endRadius: 200)

    var body: some View {
        GeometryReader { geo in

//            VStack {
//                Spacer()
//                Rectangle()
//                    .fill(rGradient)
            Image("waveBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(.regularMaterial)
//                .frame(height: geo.size.height * 0.7)
//                .fadeEffect()
                .ignoresSafeArea(edges: .top)
//            }
//                .edgesIgnoringSafeArea(.all) // Extend to the entire screen

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
//        .ignoresSafeArea()
    }

    func snow(geo: GeometryProxy) -> some View {
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
    }
}

#Preview {
    OnboardingBackground()
}
