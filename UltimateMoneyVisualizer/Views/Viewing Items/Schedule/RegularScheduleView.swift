//
//  RegularScheduleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//


import SwiftUI
import CoreData

struct RegularScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkSchedule.dayOfWeek, ascending: true)],
        animation: .default)
    private var workSchedules: FetchedResults<WorkSchedule>

    var body: some View {
        List {
            ForEach(workSchedules, id: \.self) { workSchedule in
                HStack {
                    Text(workSchedule.dayOfWeek ?? "")
                    Spacer()
                    Text("\(workSchedule.startTime!, formatter: timeFormatter) - \(workSchedule.endTime!, formatter: timeFormatter)")
                }
            }
        }
        .navigationTitle("Work Schedules")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit") {
                    SelectRegularDaysView()
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

struct RegularScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        RegularScheduleView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}

