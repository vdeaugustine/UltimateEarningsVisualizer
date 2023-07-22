//
//  TodayView+SubViews.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/22/23.
//

import Foundation
import SwiftUI

// MARK: - View functions and computed properties

extension TodayView {
    // MARK: - AnimatePlusAmount

    struct AnimatePlusAmount: View {
        let str: String
        @State private var animate: Bool = true
        @ObservedObject private var settings = User.main.getSettings()
        var body: some View {
            VStack {
                Text(str)
                    .font(.footnote)
                    .foregroundColor(settings.themeColor)
                    .offset(y: animate ? -15 : -5)
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1.3 : 0.7)
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in

                if self.animate == true {
                    self.animate = false
                } else {
                    withAnimation(Animation.easeOut(duration: 1)) {
                        if self.animate == false {
                            self.animate = true
                        }
                    }
                }
            }
        }
    }


    struct TimeMoneyPicker: View {
        @EnvironmentObject private var viewModel: TodayViewModel

        var body: some View {
            Picker("Time/Money", selection: $viewModel.selectedSegment) {
                ForEach(TodayViewModel.SelectedSegment.allCases) { segment in
                    Text(segment.rawValue.capitalized)
                        .tag(segment)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }

    // MARK: - Start End Total

    struct StartEndTotalView: View {
        @EnvironmentObject private var viewModel: TodayViewModel

        var body: some View {
            VStack {
                Text("Hours for \(Date.now.getFormattedDate(format: .abreviatedMonth))")
                    .font(.headline)
                    .spacedOut {
                        Button {
                            viewModel.showHoursSheet.toggle()
                        } label: {
                            Text("Edit")
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)

                if let start = viewModel.user.todayShift?.startTime,
                   let end = viewModel.user.todayShift?.endTime,
                   let totalDuration = viewModel.user.todayShift?.totalShiftDuration,
                   let totalWillEarn = viewModel.user.todayShift?.totalWillEarn {
                    HorizontalDataDisplay(data: [.init(label: "Start",
                                                       value: start.getFormattedDate(format: .minimalTime, amPMCapitalized: false),
                                                       view: nil),
                                                 .init(label: "End",
                                                       value: end.getFormattedDate(format: .minimalTime, amPMCapitalized: false),
                                                       view: nil),
                                                 viewModel.selectedSegment == .time ?
                                                     .init(label: "Total",
                                                           value: totalDuration.formatForTime(),
                                                           view: nil) :
                                                     .init(label: "Will Earn",
                                                           value: totalWillEarn.money(),
                                                           view: nil)])
                }
            }
        }
    }

    // MARK: - Individual Views

    struct ProgressSectionView: View {
        @EnvironmentObject private var viewModel: TodayViewModel

        var body: some View {
            VStack {
                HStack {
                    Text(viewModel.selectedSegment.rawValue.capitalized)
                    Spacer()
                    Text(viewModel.totalValueForProgressSection())
                }

                ZStack {
                    ProgressBar(percentage: viewModel.todayShiftPercentCompleted,
                                color: viewModel.settings.themeColor)
                    if viewModel.wage.includeTaxes {
                        ProgressBar(percentage: min(viewModel.todayShiftPercentCompleted,
                                                    viewModel.wage.totalTaxMultiplier),
                                    color: .niceRed,
                                    showBackgroundBar: false)
                    }
                }

                HStack {
                    Text(viewModel.soFarTotalValue)
                    Spacer()
                    Text(viewModel.todayShiftRemainingValue)
                }

                HStack {
                    Circle()
                        .frame(width: 8)
                        .foregroundStyle(Color.niceRed)
                    Text("Taxes")
                        .font(.caption2)
                    Spacer()
                }
                .offset(y: 20)
            }
            .font(.footnote)
            .padding()
            .padding(.top)
            .overlay {
                if viewModel.isCurrentlyMidShift {
                    AnimatePlusAmount(str: "+" + (viewModel.wage.perSecond * 2)
                        .moneyExtended())
                }
            }
        }
    }

    // MARK: - Payoff Item Section

    // MARK: - Today's Spending Section

    struct TodaysSpendingView: View {
        @EnvironmentObject private var viewModel: TodayViewModel

        var body: some View {
            VStack {
                HStack {
                    Text("Today's Spending")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()

                    NavigationLink("Edit Queue") {
                        PayoffQueueView()
                    }
                }

                TodayPayoffGrid()
            }
            .padding()
            .padding(.vertical)
            .background(Color.white)
        }
    }
}

// struct TodayViewSubviews_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView.ProgressSectionView(viewModel: .init())
//            .environment(\.managedObjectContext, PersistenceController.context)
//    }
// }
