//
//  FinalOnboardingScheduleFullSheet.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingScheduleFullSheet: View {
    
    @State private var slideNumber = 1
    let totalSlideCount = 4
    
    var slidePercentage: Double {
        Double(slideNumber) / Double(totalSlideCount)
    }
    
    var body: some View {
        GeometryReader { geo in

            VStack(spacing: 30) {
                
                Progress
                    .padding(.horizontal, widthScaler(24, geo: geo))
                
                
                TabView(selection: $slideNumber) {
                    FinalOnboardingScheduleSlide1()
                        .tag(1)
                    FinalOnboardingScheduleSlide2()
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
    }
    
    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: slidePercentage,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP \(slideNumber) OF \(totalSlideCount)")
                .font(.system(.title3, design: .rounded))
        }
    }
    
    @ViewBuilder var ContinueButton: some View {
        FinalOnboardingButton(title: "Continue") {
            withAnimation {
                slideNumber += 1
            }
        }
    }
}

#Preview {
    FinalOnboardingScheduleFullSheet()
}
