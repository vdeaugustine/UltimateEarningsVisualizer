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
    @StateObject var viewModel = TodayViewModel()

    var body: some View {
        VStack {
            if viewModel.user.todayShift != nil {
                ScrollView {
                    TimeMoneyPicker(viewModel: viewModel)
                        .padding(.vertical)
                    VStack {
                        StartEndTotalView(viewModel: viewModel)
                            .padding(.top)
                        ProgressSectionView(viewModel: viewModel)
                    }
                    .padding([.vertical, .top])
                    .background(Color.white)

                    TodaysSpendingView(viewModel: viewModel)
                }

            } else {
                Spacer()
                YouHaveNoShiftView(showHoursSheet: $viewModel.showHoursSheet)
            }
        }
        .onAppear(perform: viewModel.user.updateTempQueue)
        .putInTemplate()
        .bottomBanner(isVisible: $viewModel.showBanner,
                      swipeToDismiss: false,
                      buttonText: "Save") {
            do {
                try viewModel.user.todayShift?.finalizeAndSave(user: viewModel.user, context: viewModel.viewContext)
            } catch {
                print("Error saving")
            }
        }
        .background(Color.targetGray.frame(maxHeight: .infinity).ignoresSafeArea())
        .navigationTitle("Today Live")
        .sheet(isPresented: $viewModel.showHoursSheet) {
            SelectHours(viewModel: viewModel)
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
    }
}

// MARK: - YouHaveNoShiftView

// Views like TimeMoneyPicker, SelectHours, ProgressSectionView,
// TodaysSpendingView, StartEndTotalView, YouHaveNoShiftView will remain same as I have mentioned in previous responses.

struct YouHaveNoShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showHoursSheet: Bool
    @ObservedObject var settings = User.main.getSettings()

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "calendar.badge.clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text("Today's Shift")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("You do not have a shift scheduled for today.")
                    .fontWeight(.medium)
            }

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom, content: {
            Button {
                showHoursSheet = true
            } label: {
                ZStack {
                    Capsule()
                        .fill(settings.getDefaultGradient())
                    Text("Add Shift")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(width: 135, height: 50)
            }

        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

// MARK: - TodayView_Previews

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView(viewModel: TodayViewModel())
            .putInTemplate()
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
