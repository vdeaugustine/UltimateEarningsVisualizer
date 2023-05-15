//
//  RegularScheduleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import CoreData
import SwiftUI

// MARK: - RegularScheduleView

struct RegularScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var user: User = .main

    var body: some View {
        List {
            if let schedule = user.regularSchedule {
                ForEach(schedule.getRegularDays()) { day in

                    if let dayOfWeek = day.getDayOfWeek() {
                        Section(dayOfWeek.rawValue) {
                            if let startTime = day.getStartTime() {
                                Text("Start time")
                                    .spacedOut(text: startTime.getFormattedDate(format: "h:mm a"))
                            }
                            if let endTime = day.getEndTime() {
                                Text("End time")
                                    .spacedOut(text: endTime.getFormattedDate(format: "h:mm a"))
                            }
                        }
                    }
                }
            } else {
                Text("No schedule")
            }
        }
        .putInTemplate()
        .navigationTitle("Regular Schedule")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit") {
                    SelectDaysView()
                }
            }
        }
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

// MARK: - RegularScheduleView_Previews

struct RegularScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        RegularScheduleView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInTemplate()
            .putInNavView(.inline)
    }
}
