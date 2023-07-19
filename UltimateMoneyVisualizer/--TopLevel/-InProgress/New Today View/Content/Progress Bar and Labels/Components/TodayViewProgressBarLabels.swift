//
//  TodayViewProgressBarLabels.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewProgressBarLabels: View {
    var body: some View {
        HStack {
            makePill("Taxes", color: .niceRed)
            makePill("Expenses", color: .blue)
            makePill("Goals", color: .blue)
            makePill("Unspent", color: .green)
        }
    }
    
    func makePill(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.lato(.bold, 12))
            .lineLimit(1)
            .foregroundStyle(Color.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background {
                Capsule(style: .circular)
                    .fill(color)
            }
    }
}

#Preview {
    TodayViewProgressBarLabels()
}
