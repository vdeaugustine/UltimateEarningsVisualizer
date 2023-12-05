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
    @State private var includingTaxes = User.main.getWage().includeTaxes
    @State private var showTaxesSheet = false

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
                                      valueString: viewModel.remainingTotalValue,
                                      bottomLabel: "Remaining")
                }

                HStack {
                    TodayViewInfoRect(circleColor: viewModel.taxesColor,
                                      valueString: viewModel.taxesTotalValue,
                                      bottomLabel: "Taxes")
                    .blur(radius: includingTaxes ? 0 : 10)
                    .overlay {
                        if !includingTaxes {
                            Button {
                                showTaxesSheet = true
//                                NavManager.shared.appendCorrectPath(newValue: .enterWage)
                            } label: {
                                VStack(spacing: 10) {
                                    Text("Set up taxes")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.gray)
                                }
                                .frame(height: 124)
                                .frame(maxWidth: 181)
                            }
                            
//                            .frame(maxWidth: 181, alignment: .leading)
//                            .cornerRadius(20)
//                            .modifier(ShadowForRect())
                        }
                    }

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
        .onChange(of: viewModel.wage.includeTaxes, perform: { value in
            includingTaxes = viewModel.wage.includeTaxes
        })
        .sheet(isPresented: $showTaxesSheet) {
            includingTaxes = User.main.getWage().includeTaxes
            print("Called on dismiss")
        } content: {
            NavigationView {
                EnterWageView()
            }
        }
    }
}

#Preview {
    TodayViewInfoRects().environmentObject(TodayViewModel.main)
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
