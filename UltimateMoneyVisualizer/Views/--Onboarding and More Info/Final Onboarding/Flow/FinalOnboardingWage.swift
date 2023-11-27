//
//  FinalOnboardingWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/26/23.
//

import SwiftUI

struct FinalOnboardingWage: View {
//    @ObservedObject private var settings = User.main.getSettings()
    let image: Image = Image("dollarNoBack")
    let title: String = "Set your wage and see earnings in real time"
    let subtitle1: String = "When you are currently working a shift, the app will calculate how much you are earning each second."
    let subtitle2: String = "It will even take into account your pre and post tax deductions to show you your real money that will actually show up in your next paycheck"
    let buttonTitle: String = "Enter Wage"
    let buttonAction: () -> Void = {
    }
    
    private let subtitleGray = Color(hex: "3C3C3C")

    func widthScaler(_ width: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameWidth = geo.size.width
        let coefficient = frameWidth / 430
        return coefficient * width
    }

    func heightScaler(_ height: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameHeight = geo.size.height
        let coefficient = frameHeight / 932
        return coefficient * height
    }

    func titleText(geo: GeometryProxy) -> some View {
        var attributedText = AttributedString("Set your wage and see earnings in real time")
        if let range = attributedText.range(of: "real time") {
            attributedText[range].foregroundColor = .blue
        }

        return Text(attributedText)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, widthScaler(96, geo: geo))
    }

    var body: some View {
        GeometryReader { geo in

            VStack {
                Spacer()
                    .frame(height: heightScaler(40, geo: geo))

                imageAndText(geo: geo)

                Spacer()

                OnboardingButton(title: buttonTitle, buttonAction)
                    .frame(width: widthScaler(274, geo: geo))
            }

            .frame(maxWidth: .infinity)
        }
        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
    }

    func imageAndText(geo: GeometryProxy) -> some View {
        VStack(spacing: heightScaler(27, geo: geo)) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: heightScaler(300, geo: geo))
            titleAndBody(geo: geo)
        }
    }

    func titleAndBody(geo: GeometryProxy) -> some View {
        VStack(spacing: heightScaler(27, geo: geo)) {
            titleText(geo: geo)

            Group {
                Text(subtitle1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(subtitle2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundStyle(subtitleGray)
            .padding(.trailing, widthScaler(64, geo: geo))
        }
        .padding(.leading, widthScaler(24, geo: geo))
    }
}

#Preview {
    FinalOnboardingWage()
}
