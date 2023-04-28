//
//  SelectRegularDaysView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import CoreData
import SwiftUI

// MARK: - SelectRegularDaysView

struct SelectRegularDaysView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selectedDaysOfWeek: Set<DayOfWeek> = []
    @State private var selectedDayTimes: [DayOfWeek: (startTime: Date, endTime: Date)] = [:]
    @State private var showingSheet: Bool = false
    @State private var activeDay: DayOfWeek?


    @State private var showSuccessfulSaveToast = false
    @State private var showErrorToast = false

    private var totalWorkTime: TimeInterval {
        var totalTime: TimeInterval = 0

        for (_, times) in selectedDayTimes {
            let startTime = times.startTime
            let endTime = times.endTime
            totalTime += endTime.timeIntervalSince(startTime)
        }

        return totalTime
    }

    var body: some View {
        List {
            ForEach(DayOfWeek.allCases, id: \.self) { dayOfWeek in
                let isSelected = selectedDaysOfWeek.contains(dayOfWeek)
                let timeSelection = selectedDayTimes[dayOfWeek]

                Button(action: {
                    if isSelected {
                        selectedDaysOfWeek.remove(dayOfWeek)
                        selectedDayTimes[dayOfWeek] = nil
                    } else {
                        selectedDaysOfWeek.insert(dayOfWeek)
                        activeDay = dayOfWeek
                        showingSheet = true
                    }
                }) {
                    HStack {
                        Text(dayOfWeek.rawValue)
                        Spacer()
                        if isSelected {
                            if let timeSelection = timeSelection {
                                Text("\(timeSelection.startTime, formatter: timeFormatter) - \(timeSelection.endTime, formatter: timeFormatter)")
                            } else {
                                Text("Select Time")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .allPartsTappable()
                .buttonStyle(.plain)
            }

            Section(header: Text("Total Work Time")) {
                if totalWorkTime > 0 {
                    Text("\(totalWorkTime / 3_600, specifier: "%.2f") hours per week")
                } else {
                    Text("No work time selected")
                        .foregroundColor(.secondary)
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Days of Week")
        .sheet(isPresented: $showingSheet) {
            if let activeDay = activeDay {
                TimeSelectionView(startTime: selectedDayTimes[activeDay]?.startTime, endTime: selectedDayTimes[activeDay]?.endTime) { startTime, endTime in
                    selectedDayTimes[activeDay] = (startTime: startTime, endTime: endTime)
                    showingSheet = false
                } onCancel: {
                    showingSheet = false
                }
            }
        }
        .toolbarSave {
            do {
                // First, remove all existing work schedules, assuming the user has only one schedule
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WorkSchedule.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try viewContext.execute(deleteRequest)

                // Create and save the new work schedules
                for (day, times) in selectedDayTimes {
                    let workSchedule = WorkSchedule(context: viewContext)
                    workSchedule.dayOfWeek = day.rawValue
                    workSchedule.startTime = times.startTime
                    workSchedule.endTime = times.endTime
                }
                try viewContext.save()
                
                showSuccessfulSaveToast = true
            } catch {
                print("Error saving work schedule: \(error)")
                
                showErrorToast = true
                
            }
        }
        .toast(isPresenting: $showSuccessfulSaveToast, offsetY: -100) {
            AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: "Schedule saved successfully", style: .style(backgroundColor: .white, titleColor: .black, subTitleColor: nil, titleFont: nil, subTitleFont: nil))
                
        }
        .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.blue), title: "Error saving schedule")
        } onTap: {
            showErrorToast = false
        }
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

// MARK: - TimeSelectionView

struct TimeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    let startTime: Date?
    let endTime: Date?
    let onSave: (Date, Date) -> Void
    let onCancel: () -> Void

    @State private var startDate: Date
    @State private var endDate: Date

    init(startTime: Date?, endTime: Date?, onSave: @escaping (Date, Date) -> Void, onCancel: @escaping () -> Void) {
        self.startTime = startTime
        self.endTime = endTime
        self.onSave = onSave
        self.onCancel = onCancel
        self._startDate = State(initialValue: startTime ?? .getThisTime(hour: 9, minute: 0)!)
        self._endDate = State(initialValue: endTime ?? .getThisTime(hour: 17, minute: 0)!)
    }

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                    onCancel()
                }
                Spacer()
                Button("Save") {
                    presentationMode.wrappedValue.dismiss()
                    onSave(startDate, endDate)
                }
            }
            .padding(.horizontal)
            DatePicker("Start Time", selection: $startDate, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $endDate, displayedComponents: .hourAndMinute)
        }
    }
}

// MARK: - SelectRegularDaysView_Previews

struct SelectRegularDaysView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRegularDaysView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
