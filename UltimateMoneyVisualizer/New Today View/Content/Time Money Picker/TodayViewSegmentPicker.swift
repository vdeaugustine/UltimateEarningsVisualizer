//
//  TodayViewSegmentPicker.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/21/23.
//

import SwiftUI

// MARK: - TodayViewSegmentPicker

struct TodayViewSegmentPicker: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        HStack(spacing: 16) {
            Text("Time")
                .font(.system(size: 20))
                .fontWeight(viewModel.timeSegmentLabelWeight)
                .foregroundStyle(viewModel.timeSegmentLabelColor)
                .onTapGesture(perform: viewModel.tappedTimeSegment)
            Text("Money")
                .font(.system(size: 20))
                .fontWeight(viewModel.moneySegmentLabelWeight)
                .foregroundStyle(viewModel.moneySegmentLabelColor)
                .onTapGesture(perform: viewModel.tappedMoneySegment)
        }
    }
}

// MARK: - TodayViewSegmentPicker_Previews

struct TodayViewSegmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewSegmentPicker()
            .environmentObject(TodayViewModel.main)
    }
}
