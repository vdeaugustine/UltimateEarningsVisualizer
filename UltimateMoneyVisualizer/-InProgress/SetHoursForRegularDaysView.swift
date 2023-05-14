//
//  SetHoursForRegularDaysView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import SwiftUI

// MARK: - SetHoursForRegularDaysView

struct SetHoursForRegularDaysView: View {
    @ObservedObject private var daysContainer = RegularDaysContainer.shared

    @State private var showTimeSheet = false

    @State private var selectedDay: DayOfWeek = .monday

    var body: some View {
        List {
            ForEach(daysContainer.daysOfWeekSelected) { day in

                Section(day.rawValue) {
                    Button {
                        if selectedDay == day {
                            showTimeSheet = true
                        }
                        selectedDay = day
                    } label: {
                        Text("Start")
                            .spacedOut {
                                Text(
                                    daysContainer.startTimeDict[day]?.getFormattedDate(format: .minimalTime) ?? "Not set"
                                )
                                .foregroundStyle(User.main.getSettings().getDefaultGradient())
                            }
                            .allPartsTappable()
                    }

                    .buttonStyle(.plain)

                    Button {
                        if selectedDay == day {
                            showTimeSheet = true
                        }
                        selectedDay = day
                    } label: {
                        Text("End")
                            .spacedOut {
                                Text(
                                    daysContainer.endTimeDict[day]?.getFormattedDate(format: .minimalTime) ?? "Not set"
                                )
                                .foregroundStyle(User.main.getSettings().getDefaultGradient())
                            }
                            .allPartsTappable()
                    }

                    .buttonStyle(.plain)
                }
                .onChange(of: selectedDay) { _ in
                    showTimeSheet = true
                }
            }
        }
        .onAppear {
            // TODO: Get rid of this. Only for building
            #if DEBUG
                DayOfWeek.orderedCases.forEach {
                    daysContainer.handleDayOfWeek($0)
                }
            #endif
        }

        .sheet(isPresented: $showTimeSheet) {
            TimeSheet(day: selectedDay, showHoursSheet: $showTimeSheet)
        }
        .navigationTitle("Set Hours")
        .putInTemplate()
    }

    struct TimeSheet: View {
        let day: DayOfWeek

        @ObservedObject private var daysContainer = RegularDaysContainer.shared

        @State private var start: Date = .nineAM
        @State private var end: Date = .fivePM
        @Binding var showHoursSheet: Bool

        @ObservedObject var settings = User.main.getSettings()
        @ObservedObject var user = User.main

        var body: some View {
            Form {
                DatePicker("Start Time", selection: $start, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $end, displayedComponents: .hourAndMinute)
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    daysContainer.startTimeDict[day] = start
                    daysContainer.endTimeDict[day] = end

                    showHoursSheet = false

                } label: {
                    ZStack {
                        Capsule()
                            .fill(settings.getDefaultGradient())
                        Text("Save")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(width: 135, height: 50)
                }
            }
            .navigationTitle("Set Hours For \(day.rawValue)")
            .background(Color.clear)
            .putInTemplate()
            .putInNavView(.inline)
            .presentationDetents([.medium, .fraction(0.9_999_999_999_999_999)])
            .presentationDragIndicator(.visible)
            .tint(.white)
            .accentColor(.white)
        }
    }
}

// MARK: - SetHoursForRegularDaysView_Previews

struct SetHoursForRegularDaysView_Previews: PreviewProvider {
    static var previews: some View {
        SetHoursForRegularDaysView()
            .putInNavView(.inline)
    }
}
