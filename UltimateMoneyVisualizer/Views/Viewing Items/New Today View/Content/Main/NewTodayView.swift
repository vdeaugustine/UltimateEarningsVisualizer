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
        Group {
            if viewModel.user.todayShift != nil {
                MainView_TodayView()
            } else {
                YouHaveNoShiftView(showHoursSheet: $viewModel.showHoursSheet)
            }
        }
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
        }
        .environmentObject(viewModel)
        .navigationDestination(for: NavManager.AllViews.self) { view in
            NavManager.shared.getDestinationViewForStack(destination: view)
        }
    }
}



struct MainView_TodayView : View {
    @EnvironmentObject var viewModel: TodayViewModel
    
    // MARK: - Properties
    
    
    var body: some View {
        ScrollView {
            VStack {
                headerAndBar
                Group {
                    Spacer()
                        .frame(height: 24)
                    // The totals section. The ones that tell progress by the second
                    TodayViewInfoRects()
                    Spacer()
                        .frame(height: 24)
                    // Payoff queue
//                    if !viewModel.nonZeroPayoffItems.isEmpty {
                        TodayPaidOffStackWithHeader()
//                    }
                    Spacer()
                        .frame(height: 24)
                    TodayViewItemizedBlocks()
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(UIColor.secondarySystemBackground.color)
            .frame(maxHeight: .infinity)

            Spacer()
        }
        .modifier(Modifiers())
    }
    
    
    // MARK: - Modifiers
    struct Modifiers: ViewModifier {
        @EnvironmentObject private var viewModel : TodayViewModel
        func body(content: Content) -> some View {
            content
                .background {
                    VStack(spacing: 0) {
                        viewModel.settings.themeColor.frame(height: 500)
                        UIColor.secondarySystemBackground.color.frame(maxHeight: .infinity)
                    }
                    .ignoresSafeArea()
                }
                .putInTemplate(displayMode: .inline)
                .safeAreaInset(edge: .top) {
                    viewModel.settings.themeColor
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 0)
                }
                .confirmationDialog("Delete shift?",
                                    isPresented: $viewModel.showDeleteConfirmation,
                                    titleVisibility: .visible) {
                    Button("Delete", role: .destructive, action: viewModel.deleteShift)
                }
                .onReceive(viewModel.timer) { _ in
                    viewModel.addSecond()
                }
                .onAppear(perform: viewModel.user.updateTempQueue)
                .bottomBanner(isVisible: $viewModel.showBanner,
                              mainText: "Shift Complete!",
                              buttonText: "Save",
                              buttonAction: {
                                  viewModel.navManager.appendCorrectPath(newValue: NavManager.AllViews.confirmToday)
                              }, onDismiss: {
                                  viewModel.saveBannerWasDismissed = true
                              })
            
        }
        
    }
    
    
    
    // MARK: - Sub Views
    @ViewBuilder var headerAndBar: some View {
        VStack {
            VStack(spacing: -20) {
                TodayViewHeader()

                TodayViewProgressBarAndLabels()
                    .padding(.horizontal)
            }

            TodayViewSegmentPicker()
                .padding(.top)
        }
    }
    
    
}


// MARK: - NewTodayView_Previews
   
struct NewTodayView_Previews: PreviewProvider {
    
    static let model: TodayViewModel = {
        let model = TodayViewModel(user: User.testing)
        return model
    }()
    
    static var previews: some View {
        MainView_TodayView()
            .environmentObject(model)
//        NavigationStack(path: .constant(NavManager.shared.todayViewNavPath)) {
//            NewTodayView()
//                .environmentObject(TodayViewModel.main)
//        }
    }
}

