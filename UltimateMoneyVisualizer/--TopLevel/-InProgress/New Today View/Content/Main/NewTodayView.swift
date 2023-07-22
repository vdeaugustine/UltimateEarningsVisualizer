//
//  NewTodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - NewTodayView

struct NewTodayView: View {
    @StateObject private var viewModel: TodayViewModel = .main
    var body: some View {
        ScrollView {
            VStack {
                headerAndBar
                Spacer()
                    .frame(height: 24)
                TodayViewInfoRects()
                    .padding(.horizontal)

                Spacer()
                    .frame(height: 24)

                if !viewModel.nonZeroPayoffItems.isEmpty {
                    TodayPaidOffStackWithHeader()
                        .padding(.horizontal)
                }
                Spacer()
            }
            .background(Color.targetGray)
            .frame(maxHeight: .infinity)
        }
        .toolbarColorScheme(.dark, for: .automatic)
        .background {
            VStack {
                Color(hex: "003DFF")
                    .frame(height: 355)
                Color.targetGray
            }
            .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.targetGray)
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
        }
        .onAppear(perform: viewModel.user.updateTempQueue)
        //        .putInTemplate()
        .bottomBanner(isVisible: $viewModel.showBanner,
                      mainText: "Shift Complete!",
                      buttonText: "Save",
                      destination: {
                          CompletedShiftSummary()
                      }, onDismiss: {
                          viewModel.saveBannerWasDismissed = true
                      })
    }

    var headerAndBar: some View {
        VStack {
            VStack(spacing: -30) {
                TodayViewHeader()
                TodayViewProgressBarAndLabels()
                    .padding(.horizontal)
            }

            TodayViewSegmentPicker()
        }
    }

    var infoRects: some View {
        HStack {
            TodayViewInfoRect(imageName: "hourglass", valueString: viewModel.remainingTime.breakDownTime(), bottomLabel: "Remaining")
        }
    }
}

// MARK: - NewTodayView_Previews

struct NewTodayView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodayView()
            .environmentObject(TodayViewModel.main)
    }
}
