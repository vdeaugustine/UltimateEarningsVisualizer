//
//  SlideShowWelcome.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/17/23.
//

import SwiftUI

struct SlideShowWelcome: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 50)
                Image("iconNoBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                    .background {
                        Color("AccentColor")
                            
                    }
                    .clipShape(Circle())
                    .frame(height: 100)
                    .pushLeft()
                
                VStack(spacing: 30) {
                    Text("See Your Money Grow in Real Time")
                        .font(.system(size: 44))
                        .bold()
                        .foregroundStyle(Color(hex: "FFC551"))
                    
                    Text("Transform the way you view and manage your earnings. See your money as you earn it, providing a clear, real-time picture of your financial growth. With UMV, you’re not just tracking numbers; you're actively shaping your financial future.")
                        .font(.system(size: 26))
                        .foregroundStyle(.white)
                    
                    
                }.padding(.horizontal).padding(.horizontal)
                
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                Color("AccentColor")
                
//                Color("AccentColor")
//                    .brightness(0.1)
//                    .clipShape(FirstVector())
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    SlideShowWelcome()
}
