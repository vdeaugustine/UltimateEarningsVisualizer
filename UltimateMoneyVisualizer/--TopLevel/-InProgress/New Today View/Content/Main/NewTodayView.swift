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

    var statusBarHeight: CGFloat {
        let statusBarHeight = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first?
            .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }

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
                    .frame(height: 24)

                TodayViewItemizedBlocks()
                    .padding(.horizontal)
            }
            .background(Color.targetGray)
            .frame(maxHeight: .infinity)
        }

        .background {
            VStack {
                Color(hex: "003DFF")
                    .frame(height: 355)
                Color.targetGray
            }
            .ignoresSafeArea(edges: .top)
            .frame(maxHeight: .infinity)
        }
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

        .bottomButton(label: "Save Shift") {
            viewModel.navManager.todayViewNavPath.append("s")
        }
        .navigationDestination(for: NavManager.TodayViewDestinations.self) { destination in
            switch destination {
                case .confirmShift:
                    ConfirmTodayShift().environmentObject(viewModel)
                case .payoffQueue:
                    PayoffQueueView().environmentObject(viewModel)
                case let .timeBlockDetail(block):
                    TimeBlockDetailView(block: block).environmentObject(viewModel)
                case let .goalDetail(goal):
                    GoalDetailView(goal: goal).environmentObject(viewModel)
                case let .expenseDetail(expense):
                    ExpenseDetailView(expense: expense).environmentObject(viewModel)
                case let .newTimeBlock(todayShift):
                    CreateNewTimeBlockView(todayShift: todayShift).environmentObject(viewModel)
            }
        }
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
        NavigationStack(path: .constant(NavManager.shared.todayViewNavPath)) {
            NewTodayView()
                .environmentObject(TodayViewModel.main)
        }
    }
}
