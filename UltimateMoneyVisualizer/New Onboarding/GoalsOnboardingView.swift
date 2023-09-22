//
//  GoalsOnboardingView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/20/23.
//

import SwiftUI

// MARK: - GoalsOnboardingView

struct GoalsOnboardingView: View {
    @EnvironmentObject private var vm: OnboardingModel
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Goals")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(vm.minScaleFactorForHeader)
                    .padding(.top, vm.topPadding(geo))
                    .layoutPriority(3)

                Spacer()
                Image("target2d")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, vm.horizontalPad)
                    .frame(maxWidth: geo.size.width - 60)

                Spacer()
                VStack {
                    Text("Goals are your way to set something to work towards.")
                    
                    Text("- Goal date")
                }
                    .font(.system(.title2, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, vm.horizontalPad)
                    .layoutPriority(1)

                Spacer()

                OnboardingButton(title: "Continue") {
                    vm.increaseScreenNumber()
                }
                .padding(.horizontal, vm.horizontalPad)
                .padding(.bottom, vm.padFromBottom)
                .layoutPriority(4)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - GoalsOnboardingView_Previews

struct GoalsOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsOnboardingView()
            .environmentObject(OnboardingModel.shared)
    }
}
