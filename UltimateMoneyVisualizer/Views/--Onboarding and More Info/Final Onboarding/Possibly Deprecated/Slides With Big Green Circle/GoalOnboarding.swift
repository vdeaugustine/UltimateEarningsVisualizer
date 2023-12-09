//
//  GoalOnboarding.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI

struct GoalOnboarding: View {
    // MARK: - SwipingGoalSection

    // MARK: - Body

    @Binding var tab: Int
    @State private var showInfoSheet = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    ZStack {
                        let width = geo.size.width
                        let height = geo.size.height
                        let startX = CGFloat(0)
                        let startY = CGFloat(CGFloat(height / 4 + 20) * (height / 759))
                        let endY = startY
                        let start = CGPoint(x: startX, y: startY)
                        let end = CGPoint(x: width, y: endY)
                        let controlPoint = CGPoint(x: width / 2, y: endY + (130 * (height / 759)))

                        Path { path in
                            path.move(to: start)
                            path.addQuadCurve(to: end,
                                              control: controlPoint)
                            path.addLine(to: CGPoint(x: width, y: 0))
                            path.addLine(to: .zero)
                            path.closeSubpath()
                        }
                        .fill(.tint)

                        #if DEBUG
                            // Make visible if you want to see the control points for designing
                            //                            Circle().frame(width: 10).position(controlPoint)
                        #endif

                        ImageWithCircleForOnboarding(image: "newGoalJar", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Your Goals, Visualized")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Define your financial targets with set amounts and dates, and enjoy the journey towards achieving them")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Stay inspired as you visually track your progress and see your goals coming within reach")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 20) {
                            SwipingButton(label: "Next") {
                                withAnimation {
                                    tab += 1
                                }
                            }

                            VStack {
                                Button("Learn more") {
                                    showInfoSheet = true
                                }

                                HStack {
                                    OnboardingPill(isFilled: true)
                                    OnboardingPill(isFilled: true)
                                    OnboardingPill(isFilled: false)
                                    OnboardingPill(isFilled: false)
                                }
                                .frame(maxWidth: geo.size.width * 0.45)
                                .minimumScaleFactor(0.5)
                            }
                        }

                        .layoutPriority(0)
                    }

                    .kerning(1)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                print(geo.size)
            })
            .sheet(isPresented: $showInfoSheet, content: {
                GoalsInfoView()
            })
        }
    }
}

#Preview {
    GoalOnboarding(tab: .constant(3))
}
