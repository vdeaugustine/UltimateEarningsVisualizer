//
//  SelectHoursSheet.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/21/23.
//

import SwiftUI
import Vin

// MARK: - SelectHours

struct SelectHours: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        Form {
            Section {
                DatePicker("Start Time", selection: $viewModel.start, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $viewModel.end, displayedComponents: .hourAndMinute)

                // TODO: - Remove this before finishing
//                #if DEUBG
                    Button("Testing") {
                        viewModel.start = .now.addMinutes(-3)
                        viewModel.end = .now.addMinutes(2)
                    }
//                #endif

                Button("9-5") {
                    viewModel.start = Date.getThisTime(hour: 9, minute: 0)!
                    viewModel.end = Date.getThisTime(hour: 17, minute: 0)!
                }

            } header: {
                Text("Hours").hidden()
            }

            if let regularSchedule = viewModel.user.regularSchedule,
               let forToday = regularSchedule.getRegularDays().first(where: { $0.getDayOfWeek() == DayOfWeek(date: .now) }),
               let start = forToday.getStartTime(),
               let end = forToday.getEndTime(),
               let dayOfWeek = forToday.getDayOfWeek(){
                Section("Normal \(dayOfWeek.rawValue) hours") {
                    Button {
                    } label: {
                        Text(start.getFormattedDate(format: .minimalTime) + " + " + end.getFormattedDate(format: .minimalTime))
                    }
                }
            }

            Section {
                ForEach(viewModel.user.getShifts().prefixArray(4)) { shift in
                    Button {
                    } label: {
                        if let start = shift.startDate,
                           let end = shift.endDate {
                            Text(start.getFormattedDate(format: .minimalTime) + " - " + end.getFormattedDate(format: .minimalTime))
                        }
                    }
                }

            } header: {
                Text("Reent Shifts")
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
        .presentationDetents([/*.medium, */.fraction(0.9_999_999_999_999_999)])
        .presentationDragIndicator(.visible)
        .tint(.white)
        .accentColor(.white)
    }
}

// MARK: - SelectHours_Previews

struct SelectHours_Previews: PreviewProvider {
    static var previews: some View {
        SelectHours()
            .environmentObject(TodayViewModel.main)
    }
}
