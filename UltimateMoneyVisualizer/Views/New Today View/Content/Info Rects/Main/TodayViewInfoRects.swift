//
//  TodayViewInfoRects.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayViewInfoRects

struct TodayViewInfoRects: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        VStack(spacing: 12) {
            VStack {
                // MARK: - Totals header

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
                                      valueString: viewModel.soFarTotalValue,
                                      bottomLabel: viewModel.soFarTotalLabel)
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.remainingTotalValue,
                                      bottomLabel: "Remaining")
                }
                
                HStack {
                    TodayViewInfoRect(circleColor: viewModel.taxesColor,
                                      valueString: viewModel.taxesTotalValue,
                                      bottomLabel: "Taxes")
                    
                    TodayViewInfoRect(circleColor: viewModel.expensesColor,
                                      valueString: viewModel.expensesTotalValue,
                                      bottomLabel: "Expenses")
                }
                
                HStack {
                    TodayViewInfoRect(circleColor: viewModel.goalsColor,
                                      valueString: viewModel.goalsTotalValue,
                                      bottomLabel: "Goals")
                    TodayViewInfoRect(circleColor: viewModel.unspentColor,
                                      valueString: viewModel.unspentTotalValue,
                                      bottomLabel: "Unspent")
                }
            }
            
            
//            HStack {
//                TodayViewInfoRect(imageName: "hourglass",
//                                  valueString: viewModel.elapsedTime.breakDownTime(),
//                                  bottomLabel: "Elapsed")
//                TodayViewInfoRect(imageName: "dollarsign.square",
//                                  valueString: viewModel.remainingTime.breakDownTime(),
//                                  bottomLabel: "Remaining")
//            }

//            HStack {
//                TodayViewInfoRect(imageName: "hourglass",
//                                  valueString: viewModel.remainingTime.breakDownTime(),
//                                  bottomLabel: "Remaining")
//                TodayViewInfoRect(imageName: "dollarsign.square",
//                                  valueString: viewModel.willEarn.money(),
//                                  bottomLabel: "Will earn")
//            }
        }
    }
}

// MARK: - TodayViewInfoRects_Previews

struct TodayViewInfoRects_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.targetGray
            VStack {
                TodayViewInfoRects()
                    .onReceive(TodayViewModel.main.timer,
                               perform: { _ in
                                   TodayViewModel.main.addSecond()
                               })
                    .environmentObject(TodayViewModel.main)
                
                Button("Toggle") {
                    TodayViewModel.main.selectedSegment.toggle()
                }
            }
        }
        .onAppear(perform: {
            
            TodayViewModel.main.user.todayShift?.startTime = .now.addMinutes(-20)
            TodayViewModel.main.user.todayShift?.endTime = .now.addMinutes(5)
        })
    }
}
