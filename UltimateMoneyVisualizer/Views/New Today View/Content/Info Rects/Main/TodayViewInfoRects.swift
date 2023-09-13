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
                                      bottomLabel: viewModel.soFarTotalLabel)
                    TodayViewInfoRect(imageName: "dollarsign.circle",
                                      valueString: viewModel.afterTaxTotalValue,
                                      bottomLabel: "After Tax")
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
