//
//  FinalOnboardingWageWalkThrough.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/30/23.
//

import SwiftUI

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

// MARK: - FinalOnboardingWageWalkThrough

struct FinalOnboardingWageWalkThrough: View {
    @StateObject private var viewModel = FinalWageViewModel()

    func thisOffset(_ width: CGFloat) -> CGFloat {
        let number = 1
        let difference = number - viewModel.slideNumber
        return width * CGFloat(difference)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                Progress
                    .padding(.horizontal, widthScaler(24, geo: geo))

                TabView(selection: $viewModel.stepNumber) {
                    FinalOnboardingWageTypeAndAmount()
                        .tag(1)
                    FinalOnboardingWageDeductions()
                        .tag(2)
                    FinalOnboardingWageAssumptions()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .background {
            OnboardingBackground().ignoresSafeArea()
        }
        .environmentObject(viewModel)
        // Do not let it go past first slide if wage amount is not set
        .onChangeProper(of: viewModel.stepNumber) {
            if viewModel.wageAmount == nil {
                viewModel.stepNumber = 1
            }
        }
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: viewModel.stepPercentage,
                        height: 8,
                        color: Color.accentColor,
                        completeColor: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP \(viewModel.stepNumber) OF \(viewModel.totalStepCount)")
                .font(.system(.title3, design: .rounded))
        }
    }
}

#Preview {
    FinalOnboardingWageWalkThrough()
}
