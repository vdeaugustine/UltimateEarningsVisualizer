//
//  MainTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

struct MainTimeBlockView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("All time blocks")
                        
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                
                .background {
                    Color(.tertiarySystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
                
                
            }
            .background(Color(.secondarySystemBackground))
        }
        .putInTemplate(title: "Time Blocks")
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    MainTimeBlockView()
//        .preferredColorScheme(.dark)
        .putInNavView(.large)
}
