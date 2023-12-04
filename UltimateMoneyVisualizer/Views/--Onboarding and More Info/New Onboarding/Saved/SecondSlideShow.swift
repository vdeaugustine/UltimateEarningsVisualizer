//
//  SecondSlideShow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/12/23.
//

import SwiftUI
import Vin

struct SecondSlideShow: View {
    @State private var tab: Int = 0
    @State private var lowestPointOfLowestView: CGFloat = 0
    @State private var remainingLowerSpace: CGFloat = 0

    func BackgroundCurve(geo: GeometryProxy) -> some View {
        ZStack {
            let width = geo.size.width
            let height = geo.size.height
            let startX = CGFloat(width / 5)
            let startY = CGFloat(0)
            let endX = width
            let endY = (height / 6)
            let start = CGPoint(x: startX, y: startY)
            let end = CGPoint(x: width, y: endY)
            let controlPoint1 = CGPoint(x: width / 2, y: (endY / 2) + 60)
            let controlPoint2 = CGPoint(x: endX - 30, y: endY)

//            UIColor.secondarySystemBackground.color

            Path { path in
                path.move(to: start)
                path.addCurve(to: end, control1: controlPoint1, control2: controlPoint2)
                path.addLine(to: CGPoint(x: width, y: 0))
                path.closeSubpath()
            }
            .fill(.tint)

            #if DEBUG
                // Make visible if you want to see the control points for designing
//                Circle().frame(width: 10).position(controlPoint1)
//                Circle().frame(width: 10).position(controlPoint2)
            #endif

            Image("iconNoBackground")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .position(x: width - 50, y: endY / 2 + 10)
        }

        .ignoresSafeArea()
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                BackgroundCurve(geo: geo)

                VStack {
                    Title(geo: geo)

                    TabViewSection

                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
            .kerning(1)
            .onChangeProper(of: lowestPointOfLowestView) {
                remainingLowerSpace = geo.frame(in: .global).maxY - lowestPointOfLowestView
                print("Remaining lower space: ", remainingLowerSpace)
            }
        }
    }

    func Title(geo: GeometryProxy) -> some View {
        HStack {
            Text("Ultimate\nMoney Visualizer")
                .font(.title)
                .fontWeight(.medium)

//                            .padding(.leading, 10)
                .padding([.top], 40)
                .frame(maxWidth: geo.size.width / 3 * 2)
                .layoutPriority(4)

            Spacer()
        }
    }

    var TabViewSection: some View {
        TabView(selection: $tab) {
            VStack {
                Slide(image: "welcomePlaceholderClear",
                      title: "Welcome!",
                      subtitles: ["Embark on a journey to financial clarity and freedom."],
                      spacer: false)
                    .layoutPriority(2)

                ExploreFeaturesBox
                    .getFrame { frame in
                        lowestPointOfLowestView = frame.maxY
                    }
                    .padding(.top, remainingLowerSpace > 70 ? 40 : 0)
            }
            
            .tag(0)

            Slide(image: "timeToMoney",
                  title: "Earnings in Real-Time",
                  subtitles: ["Watch your earnings increase as you work, visualizing your financial growth",
                              "Review your shift history to track daily earnings and understand your income patterns"])
                .tag(1)

            Slide(image: "goalJar",
                  title: "Your Goals, Visualized",
                  subtitles: ["Define your financial targets with set amounts and dates, and enjoy the journey towards achieving them",
                              "Stay inspired as you visually track your progress and see your goals coming within reach"])
                .tag(2)

            Slide(image: "expense",
                  title: "Streamline Your Expenses",
                  subtitles: ["Effortlessly monitor both recurring and one-time expenses",
                              "Prioritize your financial obligations and celebrate as you direct your earnings towards personal gains"])
                .tag(3)

            Slide(image: "timeToExpense",
                  title: "Smart Money Allocation",
                  subtitles: ["Allocate your earnings and savings to efficiently manage expenses and goals",
                              "Gain clarity on your finances with a visual representation of each paid item and its source"])
                .tag(4)

            Slide(image: "cloud",
                  title: "iCloud Integration: Safe & Synced",
                  subtitles: ["Experience the peace of mind with your data securely stored and backed up in iCloud",
                              "Effortlessly sync and restore your financial data, worry-free, even if you switch devices or reinstall the app"])
                .tag(5)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .toolbar(.hidden, for: .tabBar)
        .frame(height: remainingLowerSpace > 70 ? 600 : 500) // Adjust this height to fit your content appropriately
        .padding(.bottom, 10)
    }

    var ExploreFeaturesBox: some View {
        GroupBox {
            Text("Swipe to discover how our app can transform your financial management")
                .font(.footnote)
                .layoutPriority(1)

        } label: {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundStyle(.yellow)
                Text("Explore the Key Features:")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding([.bottom, .horizontal])
        .padding(.bottom, 10) // Reduced bottom padding
        .layoutPriority(0)
    }

    var ExampleShiftRow: some View {
        HStack {
            Text(Date.now.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(Color.defaultColorOptions.first!.getGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(Date.nineAM.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(UIColor.label.color)

                Text("Duration: \(Double(8 * 60 * 60).formatForTime())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text("$$$")
                    .font(.subheadline)
                    .foregroundColor(UIColor.label.color)
                    .multilineTextAlignment(.trailing)

                Text("earned")
                    .font(.caption2)
                    .foregroundStyle(UIColor.secondaryLabel.color)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background {
            UIColor.secondarySystemBackground.color
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    func Slide(image: String, title: String, subtitles: [String], spacer: Bool = true) -> some View {
        VStack {
            if spacer {
                Spacer()
            }
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 50)
                .frame(height: 200)
                .getFrame(in: .global) { frame in
                    print("Image info for \(image) in Global:")
                    print("Frame: \(frame)")
                    print("Top of frame \(frame.minY)")
                }
//                .getFrame(in: .local) { frame in
//                    print("Image info for \(image) in Local:")
//                    print("Frame: \(frame)")
//                    print("Top of frame \(frame.minY)")
//                }

            VStack(spacing: 30) {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 20) {
                    ForEach(subtitles, id: \.self) { subtitle in
                        Text(subtitle)
                            .font(.headline)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.horizontal)

            if spacer {
                Spacer()
            }
        }
    }
}

#Preview {
    SecondSlideShow()
//        .preferredColorScheme(.dark)
}
