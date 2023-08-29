//
//  WelcomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/26/23.
//

import SwiftUI
import Vin

// MARK: - WelcomeView

struct WelcomeView: View {
    
    @EnvironmentObject private var vm: OnboardingModel
    let titles = ["Real-time Earnings Tracker",
                  "Flexible Shift Management",
                  "Goal-Oriented Savings",
                  "Comprehensive Stats Overview"]

    let descriptions = ["Watch your money grow by the second, minute, hour, and more. Know exactly what you earn, as you earn it.",
                        "Edit shifts easily, from start to end times, including breaks. Review past shifts and see your earnings at a glance.",
                        "Set, track, and visualize items you’re working to pay off. View your progress in real-time and celebrate each achievement.",
                        "Dive deep into your earnings with detailed statistics. Break down your income by week, month, or pay period with interactive bar charts"]

    let imageStrings = ["clock",
                        "calendar",
                        "target",
                        "chart.line.uptrend.xyaxis"]

    var body: some View {
        VStack {
            Text("Welcome to your Money Visualizer!")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: 350)
                .multilineTextAlignment(.center)

            Spacer()
            
            ScrollView {
                
                VStack(spacing: 28) {
                    Spacer()
                    ForEach(0 ..< 5) { num in // Replace with your data model here
                        if let title = titles.safeGet(at: num),
                           let description = descriptions.safeGet(at: num),
                           let image = imageStrings.safeGet(at: num) {
                            HStack {
                                Image(systemName: image)
                                    .foregroundColor(.blue)
                                    .font(.system(.title, weight: .regular))
                                    .frame(width: 60, height: 50)
                                    .clipped()
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(title)
                                        .font(.system(.footnote, weight: .semibold))
                                    Text(description)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                
                            }
                        }
                    }
                    
                    
                }
                
                
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
            
           bottomButtons
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30)
        .padding(.bottom, 50)
        
    }
    
    var bottomButtons: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text("Skip walkthrough")
                Image(systemName: "chevron.forward")
                    .imageScale(.small)
            }
            .foregroundColor(.blue)
            .font(.subheadline)
            
            Button {
                vm.increaseScreenNumber()
            } label: {
                Text("Continue")
                    .font(.system(.callout, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background {
                        Color.blue.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
            }
        }
    }
}

// MARK: - WelcomeView_Previews

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
                .previewDevice("iPhone SE (3rd generation)")
            WelcomeView()
                .previewDevice("iPhone 14 Pro Max")
        }
        .environmentObject(OnboardingModel())
    }
}
