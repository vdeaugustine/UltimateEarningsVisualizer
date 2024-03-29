//
//  TodayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI
import Vin

// MARK: - TodayView

struct TodayView: View {
    @StateObject var viewModel = TodayViewModel.main
    @EnvironmentObject private var navManager: NavManager

    var body: some View {
        VStack {
            if viewModel.user.todayShift != nil {
                ScrollView {
                    TimeMoneyPicker()
                        .padding(.vertical)
                    VStack {
                        StartEndTotalView()
                            .padding(.top)
                        ProgressSectionView()
                    }
                    .padding([.vertical, .top])
                    .background(Color.white)

                    TodaysSpendingView()
                }

            } else {
                Spacer()
                YouHaveNoShiftView(showHoursSheet: $viewModel.showHoursSheet)
            }
        }
        .onAppear(perform: viewModel.user.updateTempQueue)
        .putInTemplate()
        .bottomBanner(isVisible: $viewModel.showBanner,
                      mainText: "Shift Complete!",
                      buttonText: "Save",
                      destination: {
                          CompletedShiftSummary()
        }, onDismiss: {
            viewModel.saveBannerWasDismissed = true
        })
        .background(Color.targetGray.frame(maxHeight: .infinity).ignoresSafeArea())
        .navigationTitle("Today Live")
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours()
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.addSecond()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    viewModel.showDeleteWarning.toggle()
                }
            }
        }
        .confirmationDialog("Delete Today Shift", isPresented: $viewModel.showDeleteWarning, titleVisibility: .visible) {
            Button("Confirm", role: .destructive) {
                viewModel.deleteShift()
            }
        }
        .blur(radius: viewModel.nowTime < viewModel.start ? 5 : 0)
        .overlay {
            if viewModel.nowTime < viewModel.start {
                ShiftHasntStartedView()
            }
        }
        .environmentObject(viewModel)
    }
}



// MARK: - TodayView_Previews

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack(path: .constant(NavManager.shared.todayViewNavPath)) {
            TodayView(viewModel: TodayViewModel())
                .putInTemplate()
                .environment(\.managedObjectContext, PersistenceController.context)
                .environmentObject(NavManager.shared)
        }
    }
}
