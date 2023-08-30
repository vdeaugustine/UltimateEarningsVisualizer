//
//  WelcomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    @EnvironmentObject private var vm: OnboardingModel
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Welcome to your\nUltimate Money\nVisualizer")
                .font(.system(.largeTitle, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 50)
            
            Image("welcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Empower your financial journey by visualizing earnings, managing goals, and celebrating every saving.")
                .font(.system(.title2, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            OnboardingButton(title: "Let's get started!") {
                vm.increaseScreenNumber()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
            
        }
        
    }
}
                

                
                
struct OnboardingButton: View {
    
    let title: String
    let action: () -> Void
    
    init(title: String, _ action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background {
                    Color.blue.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .frame(height: 50)
        }
    }
}
// MARK: - WelcomeView_Previews

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(OnboardingModel())
    }
}
