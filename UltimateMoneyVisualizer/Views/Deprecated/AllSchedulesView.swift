//
//  AllSchedulesView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import CoreData
import SwiftUI

// MARK: - AllSchedulesView

struct AllSchedulesView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: WorkSchedule.entity(), sortDescriptors: [.init(key: "dateCreated", ascending: false)]) var workSchedules: FetchedResults<WorkSchedule>

    var body: some View {
        List {
            ForEach(workSchedules, id: \.self) { workSchedule in
                NavigationLink(destination: RegularScheduleView()) {
                    if let day = workSchedule.dayOfWeek {
                        Text(day)
                    }

                    if let dateCreated = workSchedule.dateCreated {
                        Text(dateCreated.getFormattedDate(format: .monthDay))
                    }
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    let workSchedule = workSchedules[index]
                    context.delete(workSchedule)
                }
                do {
                    try context.save()
                } catch {
                    print("Error deleting work schedule: \(error.localizedDescription)")
                }
            }
        }
        .toolbarAdd {
            SelectRegularDaysView()
        }
    }
}

// MARK: - AllSchedulesView_Previews

struct AllSchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        AllSchedulesView()
    }
}
