//
//  TutorialsCompletedView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import SwiftUI

struct TutorialsCompletedView: View {
    // MARK: - SwipingGoalSection

    // MARK: - Body

    @Binding var tab: Int
    @State private var showInfoSheet = false

    @ObservedObject private var settings = User.main.getSettings()

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

                        ImageWithCircleForOnboarding(image: "congrats", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Great Job!")
                            .font(.title, design: .rounded)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                                Text("You have finished all of the tutorials and onboarding!")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.body, design: .rounded)
                                GroupBox {
                                    Text("You can always revisit the tutorials and learn more about how to use the app by visiting the 'Tutorials and More Info' section in the Settings tab")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.footnote, design: .rounded)
                                } label: {
                                    HStack {
                                        Image(systemName: "lightbulb")
                                            .foregroundStyle(.yellow)
                                        Text("Don't forget:")
                                            .font(.subheadline, design: .rounded)
                                            .fontWeight(.medium)
                                    }
                                }
                                
                                
                                //                                .foregroundStyle(UIColor.secondaryLabel.color)
                            }
                            .padding(.horizontal, 10)
                            .layoutPriority(1)
                        }

                        Spacer()

                        VStack(spacing: 20) {
                            SwipingButton(label: "Next") {
                                withAnimation {
                                    tab += 1
                                }
                            }

                            VStack {
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

//                    .kerning(1)

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

    var mockSettings: some View {
        VStack(spacing: 0) {
            VStack(spacing: 7) {
                Text("TUTORIALS AND MORE INFO")
                    .font(.system(size: 13))
                    .foregroundStyle(UIColor.secondaryLabel.color)
                    .pushLeft()
                    .padding(.leading, 16)
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(UIColor.systemBackground.color)
                        .frame(height: 44)
                        .overlay {
                            HStack {
                                Image(systemName: "bookmark.fill")
                                    .foregroundStyle(settings.themeColor)
                                Text("Tutorials")
                                Spacer()
                                Components.nextPageChevron
                            }
                            .padding()
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .background {
                UIColor.secondarySystemBackground.color
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }

            settingsTab
        }
        .background {
            UIColor.systemBackground.color
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 1.5, x: 0, y: 1)
        }
    }

    private var settingsTab: some View {
        VStack(spacing: 7) {
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 0.33)
            VStack(spacing: 7) {
                Image(systemName: "gear")
                    .font(.system(size: 28))

                Text("Settings")
            }
            .padding(.bottom, 7)
        }
        .foregroundStyle(settings.themeColor)
        .fontWeight(.medium)
        .frame(maxWidth: .infinity)
        .background {
            UIColor.systemBackground.color
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }
}

#Preview {
    TutorialsCompletedView(tab: .constant(0))
}
