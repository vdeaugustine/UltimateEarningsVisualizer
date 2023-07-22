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
                .font(.lato(20))
                .fontWeight(viewModel.timeSegmentLabelWeight)
                .onTapGesture(perform: viewModel.tappedTimeSegment)
                .foregroundStyle(viewModel.timeSegmentLabelColor)
            Text("Money")
                .font(.lato(20))
                .fontWeight(viewModel.moneySegmentLabelWeight)
                .onTapGesture(perform: viewModel.tappedMoneySegment)
                .foregroundStyle(viewModel.moneySegmentLabelColor)
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
