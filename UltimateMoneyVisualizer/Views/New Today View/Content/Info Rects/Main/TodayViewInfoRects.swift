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
    let height: CGFloat = 115
    let titleFont: Font = .headline
    let subtitleFont: Font = .callout
    let imageFont: CGFloat = 20

    var body: some View {
        VStack(spacing: 12) {
            VStack {
                // MARK: - Totals header

                HStack {
                    Text("TOTALS")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .tracking(1)
                        .foregroundStyle(Color(hex: "4E4E4E"))
                    Spacer()
                }

                HStack {
                    TodayViewInfoRect(imageName: "stopwatch",
                                      valueString: viewModel.soFarTotalValue,
                                      bottomLabel: viewModel.soFarTotalLabel,
                                      isPayOffItem: false,
                                      circleColor: viewModel.goalsColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.afterTaxTotalValue,
                                      bottomLabel: "After Tax",
                                      isPayOffItem: false,
                                      circleColor: viewModel.goalsColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.taxesTotalValue,
                                      bottomLabel: "Taxes",
                                      isPayOffItem: true,
                                      circleColor: viewModel.taxesColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }

                HStack {
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.taxesTotalValue,
                                      bottomLabel: "Taxes",
                                      isPayOffItem: true,
                                      circleColor: viewModel.taxesColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.expensesTotalValue,
                                      bottomLabel: "Expenses",
                                      isPayOffItem: true,
                                      circleColor: viewModel.expensesColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.goalsTotalValue,
                                      bottomLabel: "Goals",
                                      isPayOffItem: true,
                                      circleColor: viewModel.goalsColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }
//
                HStack {
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.unspentTotalValue,
                                      bottomLabel: "Unspent",
                                      isPayOffItem: true,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Elapsed",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    
                    TodayViewInfoRect(imageName: "dollarsign.square",
                                      valueString: viewModel.remainingTime.breakDownTime(),
                                      bottomLabel: "Remaining",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
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
