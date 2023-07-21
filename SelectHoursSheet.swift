//
//  SelectHoursSheet.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/21/23.
//

import SwiftUI

struct SelectHours: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        Form {
            DatePicker("Start Time", selection: $viewModel.start, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $viewModel.end, displayedComponents: .hourAndMinute)
            
            
            // TODO: - Remove this before finishing
            Button("Testing") {
                viewModel.start = .now.addMinutes(-3)
                viewModel.end = .now.addMinutes(2)
            }
            
            Button("9-5") {
                viewModel.start = Date.getThisTime(hour: 9, minute: 0)!
                viewModel.end = Date.getThisTime(hour: 17, minute: 0)!
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                do {
                    try TodayShift(startTime: viewModel.start,
                                            endTime: viewModel.end,
                                            user: viewModel.user,
                                            context: viewModel.viewContext)

                    // TODO: See if these are needed
//                        viewModel.todayShift = ts
//                        viewModel.user.todayShift = ts
                    viewModel.showHoursSheet = false

                } catch {
                    fatalError(error.localizedDescription)
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

struct SelectHours_Previews: PreviewProvider {
    static var previews: some View {
        SelectHours()
            .environmentObject(TodayViewModel.main)
            
    }
}
