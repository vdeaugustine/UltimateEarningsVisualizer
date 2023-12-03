//
//  FinalOnboardingScheduleFullSheet.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingScheduleFullSheet: View {
    @StateObject private var viewModel: FinalOnboardingScheduleViewModel = .init()
    @State private var showSheet = true


    

    var body: some View {
        GeometryReader { geo in

            VStack(spacing: 30) {
                Progress
                    .padding(.horizontal, widthScaler(24, geo: geo))

                TabView(selection: $viewModel.slideNumber) {
                    FinalOnboardingScheduleSlide1()
                        .tag(1)
                    FinalOnboardingScheduleConfirm()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)

                ContinueButton
                    .padding(.horizontal, widthScaler(20, geo: geo))
                    .padding(.bottom, 5)
            }
        }
        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
        .environmentObject(viewModel)
        .onChangeProper(of: viewModel.daysSelected) {
        }
        .sheet(isPresented: $showSheet, content: {
            FinalOnboardingSchedule()
                
        })
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: viewModel.slidePercentage,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP \(viewModel.slideNumber) OF \(viewModel.totalSlideCount)")
                .font(.system(.title3, design: .rounded))
        }
    }

    @ViewBuilder var ContinueButton: some View {
        FinalOnboardingButton(title: "Continue") {
            withAnimation {
                if viewModel.slideNumber < viewModel.totalSlideCount {
                    viewModel.slideNumber += 1
                }
//                if slideNumber <
//                slideNumber += 1
            }
        }
    }
}

#Preview {
    FinalOnboardingScheduleFullSheet()
}
