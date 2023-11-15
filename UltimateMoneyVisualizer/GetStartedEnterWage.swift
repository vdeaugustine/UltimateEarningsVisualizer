//
//  GetStartedEnterWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/13/23.
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

// MARK: - ProgressPill

struct ProgressPill: View {
    let isFilled: Bool
    var height: CGFloat = 7
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(isFilled ? .accentColor : Color.secondary, lineWidth: 2)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(isFilled ? Color.accentColor : Color.clear)
    }
}

// MARK: - SlideContent

struct SlideContent {
    let header: String
}

// MARK: - Swiping

// struct GetStartedEnterWage: View {
//    // (393.0, 759.0)
//
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                VStack {
//                    ZStack {
//                        let width = geo.size.width
//                        let height = geo.size.height
//                        let startX = CGFloat(0)
//                        let startY = CGFloat(CGFloat(height / 4 + 20) * (height / 759))
//                        let endY = startY
//                        let start = CGPoint(x: startX, y: startY)
//                        let end = CGPoint(x: width, y: endY)
//                        let controlPoint = CGPoint(x: width / 2, y: endY + (130 * (height / 759)))
//
//                        Path { path in
//                            path.move(to: start)
//                            path.addQuadCurve(to: end,
//                                              control: controlPoint)
//                            path.addLine(to: CGPoint(x: width, y: 0))
//                            path.addLine(to: .zero)
//                            path.closeSubpath()
//                        }
//                        .fill(.tint)
//
//                        #if DEBUG
//                            // Make visible if you want to see the control points for designing
////                            Circle().frame(width: 10).position(controlPoint)
//                        #endif
//
//                        ImageWithCircleForOnboarding(image: "moneyCalendar", size: geo.size)
//                            .position(x: geo.frame(in: .global).midX, y: endY)
//                    }
//                    .frame(height: 350 * (geo.size.height / 759))
//
//                    .ignoresSafeArea()
//
//                    VStack(spacing: 20) {
//                        Text("Get Started With Wage")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .pushLeft()
//                            .padding(.leading)
//
//                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
//                            Text("Unlock personalized finance insights by entering your wage!")
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            Text("Get started to see your earnings increase in real time!")
//                                .frame(maxWidth: .infinity, alignment: .leading)
////                                .foregroundStyle(UIColor.secondaryLabel.color)
//                        }
//
//                        Spacer()
//
//                        VStack(spacing: 40) {
//                            Button {
//                            } label: {
//                                Text("Let's Get Started!")
//                                    .fontWeight(.medium)
//                                    .foregroundStyle(.white)
//                                    .padding()
//                                    .padding(.horizontal)
//                                    .background {
//                                        Color.accentColor
//                                    }
//                                    .clipShape(Capsule(style: .circular))
//                            }
//
//                            HStack {
//                                ProgressPill(isFilled: true)
//                                ProgressPill(isFilled: true)
//                                ProgressPill(isFilled: false)
//                                ProgressPill(isFilled: false)
//                            }
//                            .frame(maxWidth: geo.size.width * 0.45)
//                        }
//                    }
//                    .padding()
//                    .kerning(1)
//
//                    Spacer()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .onAppear(perform: {
//                print(geo.size)
//            })
//        }
//    }
// }

struct Swiping: View {
    @State private var tab: Int = 0
    var body: some View {
        TabView(selection: $tab) {
            WageSection
            GoalSection
            ExpenseSection
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: .top)
    }

    var WageSection: some View {
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

                        ImageWithCircleForOnboarding(image: "moneyCalendar", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Get Started With Wage")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Unlock personalized finance insights by entering your wage!")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Get started to see your earnings increase in real time!")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 40) {
                            Button {
                                withAnimation {
                                    tab += 1
                                }
                            } label: {
                                Text("Let's Get Started!")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .padding(.horizontal)
                                    .background {
                                        Color.accentColor
                                    }
                                    .clipShape(Capsule(style: .circular))
                            }

                            HStack {
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: false)
                                ProgressPill(isFilled: false)
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
        }
        .tag(0)
    }

    var GoalSection: some View {
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
                        Text("Get Started With Wage")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Unlock personalized finance insights by entering your wage!")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Get started to see your earnings increase in real time!")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 40) {
                            Button {
                                withAnimation {
                                    tab += 1
                                }
                            } label: {
                                Text("Let's Get Started!")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .padding(.horizontal)
                                    .background {
                                        Color.accentColor
                                    }
                                    .clipShape(Capsule(style: .circular))
                            }

                            HStack {
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: false)
                                ProgressPill(isFilled: false)
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
        }
        .tag(1)
    }

    var ExpenseSection: some View {
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
                            Button {
                                withAnimation {
                                    tab += 1
                                }
                            } label: {
                                Text("Let's Get Started!")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .padding(.horizontal)
                                    .background {
                                        Color.accentColor
                                    }
                                    .clipShape(Capsule(style: .circular))
                            }

                            HStack {
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: false)
                                ProgressPill(isFilled: false)
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
        }
        .tag(2)
    }

    var AllocationsSection: some View {
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

                        ImageWithCircleForOnboarding(image: "expense", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Streamline Your Expenses")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Effortlessly monitor both recurring and one-time expenses")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Prioritize your financial obligations and celebrate as you direct your earnings towards personal gains")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 40) {
                            Button {
                                withAnimation {
                                    tab += 1
                                }
                            } label: {
                                Text("Let's Get Started!")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .padding(.horizontal)
                                    .background {
                                        Color.accentColor
                                    }
                                    .clipShape(Capsule(style: .circular))
                            }

                            HStack {
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: true)
                                ProgressPill(isFilled: false)
                                ProgressPill(isFilled: false)
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
        }
        .tag(2)
    }
}

#Preview {
    Swiping()
}
