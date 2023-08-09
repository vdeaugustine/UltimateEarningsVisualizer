//
//  TodayPaidOffRectContainer.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayPaidOffRectContainer<Content: View>: View {
    let content: Content

    init(content: Content = EmptyView()) {
        self.content = content
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 0.5)
                .fill(Color.white)
                /*shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)*/
                .frame(height: 100)
                .modifier(ShadowForRect())
            
            content
        }
        
        .frame(height: 100)
        
           
            
    }
}

#Preview {
    TodayPaidOffRectContainer {
        VStack {
            Text("HI")
        }
    }
    .environmentObject(TodayViewModel.main)
}
