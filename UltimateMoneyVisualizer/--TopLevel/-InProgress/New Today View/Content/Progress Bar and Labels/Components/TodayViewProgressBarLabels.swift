//
//  TodayViewProgressBarLabels.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewProgressBarLabels: View {
    @ObservedObject var viewModel: TodayViewModel
    var body: some View {
        HStack {
            makePill("Taxes", color: viewModel.taxesColor)
            makePill("Expenses", color: viewModel.expensesColor)
            makePill("Goals", color: viewModel.goalsColor)
            makePill("Unspent", color: viewModel.unspentColor)
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
    ZStack {
        Color.targetGray
        TodayViewProgressBarLabels(viewModel: .main)
    }
}
