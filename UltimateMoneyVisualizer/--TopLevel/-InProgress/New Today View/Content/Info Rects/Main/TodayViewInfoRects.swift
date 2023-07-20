//
//  TodayViewInfoRects.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

struct TodayViewInfoRects: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TodayViewInfoRect(imageName: "stopwatch",
                                  valueString: viewModel.remainingTime.breakDownTime(),
                                  bottomLabel: "Elapsed")
                TodayViewInfoRect(imageName: "dollarsign.circle",
                                  valueString: viewModel.haveEarned.formattedForMoney(),
                                  bottomLabel: "Earned")
            }
            HStack {
                TodayViewInfoRect(imageName: "hourglass",
                                  valueString: viewModel.remainingTime.breakDownTime(),
                                  bottomLabel: "Remaining")
                TodayViewInfoRect(imageName: "dollarsign.square",
                                  valueString: viewModel.willEarn.formattedForMoney(),
                                  bottomLabel: "Will earn")
            }
        }
    }
}

#Preview {
    ZStack{
        Color.targetGray
        TodayViewInfoRects()
            .onReceive(TodayViewModel.main.timer, perform: { _ in
                TodayViewModel.main.addSecond()
            })
            .environmentObject(TodayViewModel.main)
    }
}
