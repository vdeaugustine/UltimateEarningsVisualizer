//
//  FinalOnboardingSchedule.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/26/23.
//

import SwiftUI

struct FinalOnboardingScheduleInfo: View {
    @ObservedObject private var masterAppViewModel = MasterTheAppViewModel.shared
    //    @ObservedObject private var settings = User.main.getSettings()
    let image: Image = Image("moneyCalendar")
    let title: String = "Set your schedule and let the app do the rest"
    let subtitle1: String = "Shifts will be generated for you automatically, instead of requiring you to create them manually. "
    let subtitle2: String = "You can use this feature to generate future shifts to project where your money will be at any time in the future "
    let buttonTitle: String = "Enter Schedule"

    private let subtitleGray = Color(hex: "3C3C3C")

    @ViewBuilder func titleText(geo: GeometryProxy) -> some View {
        let attributedText = AttributedString(title)

        Text(attributedText)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, widthScaler(96, geo: geo))
    }

    @State private var showFullSheet = false
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in

            VStack {
                Spacer()
                    .frame(height: heightScaler(40, geo: geo))

                imageAndText(geo: geo)

                Spacer()

                FinalOnboardingButton(title: buttonTitle) {
                    dismiss()
                }
                .padding(.horizontal, widthScaler(24, geo: geo))
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
    FinalOnboardingScheduleInfo()
}
