//
//  TodayViewProgressBarAndLabels.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewProgressBarAndLabels: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    var body: some View {
        VStack(spacing: 20) {
            TodayProgressBar()
//            TodayViewProgressBarLabels()
        }
    }
}

struct TodayViewProgressBarAndLabels_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayViewProgressBarAndLabels()
                .padding(.horizontal)
                .environmentObject(TodayViewModel.main)
        }
    }
}

