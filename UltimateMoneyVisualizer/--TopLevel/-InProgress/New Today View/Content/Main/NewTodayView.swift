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

            } else {
                YouHaveNoShiftView(showHoursSheet: $viewModel.showHoursSheet)
            }
        }

        .environmentObject(viewModel)
    }
    
    init() {
        let appearance = UINavigationBarAppearance()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
            }
            .background(Color.targetGray)
            .frame(maxHeight: .infinity)
        }
        .safeAreaInset(edge: .top, content: {
            Color(hex: "003DFF")
                .frame(height: 75).ignoresSafeArea()
        })
        .confirmationDialog("Delete shift?",
                            isPresented: $viewModel.showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Confirm", role: .destructive, action: viewModel.deleteShift)
        }
        .background(background)
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
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
        
//        .navigationTitle("Today Shift")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(Color.blue.opacity(0.5))
//        .toolbarColorScheme(.dark, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
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
