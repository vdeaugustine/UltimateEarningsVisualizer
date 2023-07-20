//
//  TodayViewProgressBarAndLabels.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewProgressBarAndLabels: View {
    @ObservedObject var viewModel: TodayViewModel
    var body: some View {
        VStack(spacing: 20) {
            TodayProgressBar(viewModel: viewModel)
            TodayViewProgressBarLabels(viewModel: viewModel)
        }
    }
}

#Preview {
    ZStack {
        Color.targetGray
        TodayViewProgressBarAndLabels(viewModel: .main)
            .padding(.horizontal)
    }
    
}
