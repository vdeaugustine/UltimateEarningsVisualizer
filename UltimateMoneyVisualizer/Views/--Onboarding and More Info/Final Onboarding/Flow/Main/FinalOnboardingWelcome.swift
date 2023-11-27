//
//  FinalOnboardingWelcome.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/22/23.
//

import SwiftUI

struct FinalOnboardingWelcome: View {
    @EnvironmentObject private var vm: FinalOnboardingModel

    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Welcome to your\nUltimate Money\nVisualizer")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.9)
                    .padding(.top, vm.topPadding(geo))
                    .layoutPriority(3)

                Spacer()

                Image("guyOnPhone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, vm.horizontalPad)
                    .frame(maxWidth: geo.size.width - 60)
//                    .layoutPriority(2)
                Spacer()

                Text("Empower your financial journey by visualizing earnings, managing goals, and celebrating every saving.")
                    .font(.system(.title3, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, vm.horizontalPad)
                    .layoutPriority(1)

                Spacer()

                OnboardingButton(title: "Let's get started!") {
                    vm.advanceToNextPage()
                }
                .padding(.horizontal, vm.horizontalPad)
                .padding(.bottom, vm.padFromBottom)
                .layoutPriority(4)
            }
        }
        .background {
            OnboardingBackground()
        }
    }
}

#Preview {
    FinalOnboardingWelcome()
        .environmentObject(FinalOnboardingModel.shared)
}
