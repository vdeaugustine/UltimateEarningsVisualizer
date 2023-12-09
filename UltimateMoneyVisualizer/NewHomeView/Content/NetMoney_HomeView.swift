//
//  NetMoney_HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

// MARK: - NetMoney_HomeView

struct NetMoney_HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Net Money")
                .font(.callout)
                .fontWeight(.semibold)
            NetMoneyGraph()
        }
        .padding()
        .modifier(ShadowForRect())
        .padding(.horizontal)
        .onAppear(perform: {
            print("Color is :\(Color.accentColor) and hex:", Color.accentColor.getHex())
            print("High level accent color: \(Color("AccentColor").getHex())")
            print("\(Mirror(reflecting: Color.accentColor))")
            print("\(Mirror(reflecting: Color("AccentColor")))")
        })
    }
}

#Preview {
    NetMoney_HomeView()
}
