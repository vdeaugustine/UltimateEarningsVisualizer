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

    // MARK: - SelectHours

    struct SelectHours: View {
        @Environment(\.managedObjectContext) private var viewContext
        @ObservedObject var viewModel: TodayViewModel

        var body: some View {
            Form {
                DatePicker("Start Time", selection: $viewModel.start, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $viewModel.end, displayedComponents: .hourAndMinute)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    do {
                        let ts = try TodayShift(startTime: viewModel.start, endTime: viewModel.end, user: viewModel.user, context: viewModel.viewContext)

                        // TODO: See if these are needed
                        viewModel.todayShift = ts
                        viewModel.user.todayShift = ts
                        viewModel.showHoursSheet = false

                    } catch {
                        print(error)
                    }

                } label: {
                    ZStack {
                        Capsule()
                            .fill(viewModel.settings.getDefaultGradient())
                        Text("Save")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 135, height: 50)
                }
            }
            .navigationTitle("Set hours")
            .background(Color.clear)
            .putInTemplate()
            .putInNavView(.inline)
            .presentationDetents([.medium, .fraction(0.9_999_999_999_999_999)])
            .presentationDragIndicator(.visible)
            .tint(.white)
            .accentColor(.white)
        }
    }

    struct TimeMoneyPicker: View {
        @ObservedObject var viewModel: TodayViewModel

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
        @ObservedObject var viewModel: TodayViewModel

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

                if let start = viewModel.todayShift?.startTime,
                   let end = viewModel.todayShift?.endTime,
                   let totalDuration = viewModel.todayShift?.totalShiftDuration,
                   let totalWillEarn = viewModel.todayShift?.totalWillEarn {
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
                                                           value: totalWillEarn.formattedForMoney(),
                                                           view: nil)])
                }
            }
        }
    }

    // MARK: - Individual Views

    struct ProgressSectionView: View {
        @ObservedObject var viewModel: TodayViewModel

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
                    
                }

                HStack {
                    Text(viewModel.todayShiftValueSoFar)
                    Spacer()
                    Text(viewModel.todayShiftRemainingValue)
                }
            }
            .font(.footnote)
            .padding()
            .padding(.top)
            .overlay {
                if viewModel.isCurrentlyMidShift {
                    AnimatePlusAmount(str: "+" + (viewModel.user.getWage().secondly * 2).formattedForMoneyExtended())
                }
            }
        }
    }

    // MARK: - Payoff Item Section

    // MARK: - Today's Spending Section

    struct TodaysSpendingView: View {
        @ObservedObject var viewModel: TodayViewModel

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

                TodayPayoffGrid(viewModel: viewModel)
            }
            .padding()
            .padding(.vertical)
            .background(Color.white)
        }
    }
}

//struct TodayViewSubviews_Previews: PreviewProvider {
//    static var previews: some View {
//        TodayView.ProgressSectionView(viewModel: .init())
//            .environment(\.managedObjectContext, PersistenceController.context)
//    }
//}
