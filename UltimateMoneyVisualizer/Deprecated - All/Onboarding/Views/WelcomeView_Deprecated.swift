//
//  WelcomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI

// MARK: - WelcomeView

struct WelcomeView_Deprecated: View {
    @EnvironmentObject private var vm: OnboardingModel

    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Welcome to your\nUltimate Money\nVisualizer")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(vm.minScaleFactorForHeader)
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
                    .font(.system(.title2, design: .rounded, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, vm.horizontalPad)
                    .layoutPriority(1)

                Spacer()

                OnboardingButton(title: "Let's get started!") {
                    vm.increaseScreenNumber()
                }
                .padding(.horizontal, vm.horizontalPad)
                .padding(.bottom, vm.padFromBottom)
                .layoutPriority(4)
            }
        }
        
    }
}

// MARK: - OnboardingButton

struct OnboardingButton: View {
    let title: String
    let action: () -> Void
    let height: CGFloat
    
    @ObservedObject private var settings = User.main.getSettings()

    init(title: String, height: CGFloat = 50, _ action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.height = height
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline, design: .rounded)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .frame(height: height)
                .background {
                    Color.accentColor.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
        }
    }
}

// MARK: - WelcomeView_Previews

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView_Deprecated()
            .environmentObject(OnboardingModel())
    }
}
