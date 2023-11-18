//
//  AllocationOnboarding.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI

struct AllocationOnboarding: View {
    @EnvironmentObject private var user: User
    @State private var showError = false
    @State private var errorMessage: String = ""
    @Binding var showOnboarding: Bool
    let totalSlides: Int
    
    @Binding var tab: Int
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

                        ImageWithCircleForOnboarding(image: "timeToExpense", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Smart Money Allocation")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Allocate your earnings and savings to efficiently manage expenses and goals")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Gain clarity on your finances with a visual representation of each paid item and its source")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 40) {
                            SwipingButton(label: "Let's Get Started!") {
                                
                                do {
//                                    guard let status = user.statusTracker else {
//                                        throw NSError(domain: "Could not get status tracker", code: 0)
//                                    }
                                    let status = user.getStatusTracker()
                                    status.hasSeenOnboardingFlow = true
                                    showOnboarding = false 
                                    
                                    try user.getContext().save()
                                    print("SAVED SCC", user.getStatusTracker().hasSeenOnboardingFlow)
                                } catch {
                                    errorMessage = error.localizedDescription
                                    fatalError("There was an error: \(error)")
                                }
                            }

                            HStack {
                                ForEach(0 ..< totalSlides, id: \.self) { num in
                                    OnboardingPill(isFilled: num <= tab)
                                }
                            }
                            .frame(maxWidth: geo.size.width * 0.45)
                            .minimumScaleFactor(0.5)
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
            .alert("Error setting up user", isPresented: $showError) {
                
            } message: {
                Text(errorMessage)
            }

        }
    }
}

#Preview {
    AllocationOnboarding(showOnboarding: .constant(true), totalSlides: 5, tab: .constant(0))
}
