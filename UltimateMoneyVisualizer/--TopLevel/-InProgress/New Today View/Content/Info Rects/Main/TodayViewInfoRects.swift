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
            VStack {
                HStack {
                    Text("TOTALS")
                        .font(.lato(16))
                        .fontWeight(.semibold)
                        .tracking(1)
                        .foregroundStyle(Color(hex: "4E4E4E"))
                    Spacer()
                }
                
                HStack {
                    TodayViewInfoRect(imageName: "stopwatch",
                                      valueString: viewModel.haveEarned.money(),
                                      bottomLabel: "Earned")
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.haveEarned.money(),
                                      bottomLabel: "Earned")
                }
                
//                HStack {
//                    TodayViewInfoRect(imageName: "stopwatch",
//                                      valueString: viewModel.elapsedTime.breakDownTime(),
//                                      bottomLabel: "Earned")
//                    TodayViewInfoRect(imageName: "dollarsign.circle",
//                                      valueString: viewModel.haveEarned.money(),
//                                      bottomLabel: "Earned")
//                }
            }
            HStack {
                TodayViewInfoRect(imageName: "hourglass",
                                  valueString: viewModel.remainingTime.breakDownTime(),
                                  bottomLabel: "Remaining")
                TodayViewInfoRect(imageName: "dollarsign.square",
                                  valueString: viewModel.willEarn.money(),
                                  bottomLabel: "Will earn")
            }
            
            HStack {
                TodayViewInfoRect(imageName: "hourglass",
                                  valueString: viewModel.remainingTime.breakDownTime(),
                                  bottomLabel: "Remaining")
                TodayViewInfoRect(imageName: "dollarsign.square",
                                  valueString: viewModel.willEarn.money(),
                                  bottomLabel: "Will earn")
            }
            
        }
    }
}


struct TodayViewInfoRects_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.targetGray
            TodayViewInfoRects()
                .onReceive(TodayViewModel.main.timer,
                           perform: { _ in
                    TodayViewModel.main.addSecond()
                })
                .environmentObject(TodayViewModel.main)
        }
    }
}
