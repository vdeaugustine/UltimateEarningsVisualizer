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
                        .modifier(HeaderModifier())
                    Spacer()
                }

                HStack {
                    
                    // Earned so far / time worked so far
                    TodayViewInfoRect(imageName: "stopwatch",
                                      valueString: viewModel.soFarTotalValue,
                                      bottomLabel: viewModel.soFarTotalLabel,
                                      isPayOffItem: false,
                                      circleColor: viewModel.goalsColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    // After tax earnings
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.afterTaxTotalValue,
                                      bottomLabel: "After Tax",
                                      isPayOffItem: false,
                                      circleColor: viewModel.goalsColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    
                }

                HStack {
                    
                    // Taxes paid
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.taxesTotalValue,
                                      bottomLabel: "Taxes",
                                      isPayOffItem: true,
                                      circleColor: viewModel.taxesColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    
                    // Expenses Paid
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.expensesTotalValue,
                                      bottomLabel: "Expenses",
                                      isPayOffItem: true,
                                      circleColor: viewModel.expensesColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    // Goals Paid
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
                    // Unspent
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.unspentTotalValue,
                                      bottomLabel: "Unspent",
                                      isPayOffItem: true,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    // Time elapsed
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Elapsed",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)

                    // Time remaining
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

// MARK: - NewInfoRects

struct NewInfoRects: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    let height: CGFloat = 115
    let titleFont: Font = .headline
    let subtitleFont: Font = .callout
    let imageFont: CGFloat = 20
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Earnings")
                    .modifier(HeaderModifier())
                    .frame(alignment: .leading)
                    .pushLeft()

                HStack {
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Earned",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "After Taxes",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Remaining",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }
            }
            VStack {
                Text("Taxes")
                    .modifier(HeaderModifier())
                    .frame(alignment: .leading)
                    .pushLeft()

                HStack {
                    // After tax earnings
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.taxesPaidSoFar.money(),
                                      bottomLabel: "Paid",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.willPayInTaxes.money(),
                                      bottomLabel: "Will Pay",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.taxesRemainingToPay.money(),
                                      bottomLabel: "Remaining",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }
            }
            
            VStack {
                Text("Goals")
                    .modifier(HeaderModifier())
                    .frame(alignment: .leading)
                    .pushLeft()

                HStack {
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Paid",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Will Pay",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Remaining",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }
            }
            
            VStack {
                Text("Expenses")
                    .modifier(HeaderModifier())
                    .frame(alignment: .leading)
                    .pushLeft()

                HStack {
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Paid",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Will Pay",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                    
                    TodayViewInfoRect(imageName: "hourglass",
                                      valueString: viewModel.elapsedTime.breakDownTime(),
                                      bottomLabel: "Remaining",
                                      isPayOffItem: false,
                                      circleColor: viewModel.unspentColor,
                                      height: height,
                                      titleFont: titleFont,
                                      subtitleFont: subtitleFont,
                                      imageFontSize: imageFont)
                }
            }
        }
    }
}

// MARK: - HeaderModifier

struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .fontWeight(.semibold)
            .tracking(1)
            .foregroundStyle(Color(hex: "4E4E4E"))
    }
}

// MARK: - TodayViewInfoRects_Previews

struct TodayViewInfoRects_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ZStack{
                Color.targetGray
                VStack {
    //                TodayViewInfoRects()
                    NewInfoRects()
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

//        NewInfoRects()
            
    }
}
