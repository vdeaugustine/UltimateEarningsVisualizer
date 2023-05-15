//
//  SetHoursForRegularDaysView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - SetHoursForRegularDaysView

struct SetHoursForRegularDaysView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var daysContainer: RegularDaysContainer

    @State private var showTimeSheet = false

    @State private var selectedDay: DayOfWeek = .monday

    @State private var showAlert = false

    @State private var alertConfig = AlertToast.successWith(message: "")

    @ObservedObject private var user = User.main

    var totalTime: Double {
        var total: Double = 0
        for day in daysContainer.daysOfWeekSelected {
            guard let start = daysContainer.startTimeDict[day],
                  let end = daysContainer.endTimeDict[day]
            else {
                continue
            }
            let duration = end - start
            total += duration
        }

        return total
    }

    var totalDays: Int {
        daysContainer.daysOfWeekSelected.count
    }

    var body: some View {
        List {
            Section {
                HStack {
                    VStack {
                        Text(totalDays.str)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text("Days")
                            .fontWeight(.bold)
                            .foregroundStyle(user.getSettings().getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }

                    Divider().padding(.horizontal)

                    VStack {
                        Text(totalTime.formatForTime([.hour]))
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text("Hours")
                            .fontWeight(.bold)
                            .foregroundStyle(user.getSettings().getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }
                    
                    Divider().padding(.horizontal)
                    
                    VStack {
                        Text((totalTime / Double(totalDays)).formatForTime([.hour, .minute]))
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text("Avg")
                            .fontWeight(.bold)
                            .foregroundStyle(user.getSettings().getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }
                }
                .padding(.horizontal)
                
                .centerInParentView()
                .listRowBackground(Color.listBackgroundColor)
            }

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
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showTimeSheet) {
            TimeSheet(day: selectedDay, showHoursSheet: $showTimeSheet)
        }
        .navigationTitle("Set Hours")
        .putInTemplate()
        .bottomButton(label: "Save", padding: 50) {
            do {
                try daysContainer.finalizeAndSave(user: user, context: viewContext)
                alertConfig = .successWith(message: "Successfully saved schedule")
                showAlert.toggle()
            } catch {
                alertConfig = .errorWith(message: "Error saving schedule. Please try again.")
                showAlert.toggle()
            }
        }
        .toast(isPresenting: $showAlert) {
            alertConfig
        }
    }

    struct TimeSheet: View {
        let day: DayOfWeek

        @ObservedObject private var daysContainer = RegularDaysContainer.shared

        @State private var start: Date = RegularDaysContainer.shared.lastStart
        @State private var end: Date = RegularDaysContainer.shared.lastEnd
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
        SetHoursForRegularDaysView(daysContainer: RegularDaysContainer.shared)
            .putInNavView(.inline)
    }
}
