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

    @State var offset: CGFloat = 0

    var body: some View {
        Group {
            if viewModel.user.todayShift != nil {
                mainView
                    .safeAreaInset(edge: .top) {
                        viewModel.settings.themeColor
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 0)
                }

            } else {
                YouHaveNoShiftView(showHoursSheet: $viewModel.showHoursSheet)
            }
        }
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
        }
        .environmentObject(viewModel)
        
    }

    var mainView: some View {
        ScrollView {
            VStack {
                headerAndBar
                Group {
                    Spacer()
                        .frame(height: 24)
                    TodayViewInfoRects()

                    Spacer()
                        .frame(height: 24)

                    if !viewModel.nonZeroPayoffItems.isEmpty {
                        TodayPaidOffStackWithHeader()
                    }
                    Spacer()
                        .frame(height: 24)

                    TodayViewItemizedBlocks()

                    Spacer()
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(Color.white)
            .frame(maxHeight: .infinity)

            Spacer()
        }
        .background {
            VStack(spacing: 0) {
                viewModel.settings.themeColor.frame(height: 500)
                Color.white.frame(maxHeight: .infinity)
            }
            .ignoresSafeArea()
            
        }
        .putInTemplate(displayMode: .inline)
        .confirmationDialog("Delete shift?",
                            isPresented: $viewModel.showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Confirm", role: .destructive, action: viewModel.deleteShift)
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }

        .onAppear(perform: viewModel.user.updateTempQueue)
        .bottomBanner(isVisible: $viewModel.showBanner,
                      mainText: "Shift Complete!",
                      buttonText: "Save",
                      buttonAction: {
                          viewModel.navManager.todayViewNavPath.append(NavManager.TodayViewDestinations.confirmShift)
                      }, onDismiss: {
                          viewModel.saveBannerWasDismissed = true
                      })

        .navigationDestination(for: NavManager.TodayViewDestinations.self) {
            viewModel.navManager.getDestinationViewForTodayViewStack(destination: $0)
        }

    }

    var headerAndBar: some View {
        VStack {
            VStack(spacing: -20) {
                TodayViewHeader()

                TodayViewProgressBarAndLabels()
                    .padding(.horizontal)
            }

            TodayViewSegmentPicker()
        }
    }

    var background: some View {
        VStack {
            Color(hex: "003DFF")
                .frame(height: 355)
            Color.targetGray
        }
        .ignoresSafeArea(edges: .top)
        .frame(maxHeight: .infinity)
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

// MARK: - TodayViewPreferenceKey

struct TodayViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
