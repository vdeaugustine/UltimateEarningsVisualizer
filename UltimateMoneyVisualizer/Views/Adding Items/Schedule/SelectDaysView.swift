//
//  CreateScheduleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import CoreData
import SwiftUI

// MARK: - RegularDaysContainer

public class RegularDaysContainer: ObservableObject {
    @Published var regularDays: [RegularDay] = []

    @Published var daysOfWeekSelected: [DayOfWeek] = User.main.regularSchedule?.getDays() ?? []

    @Published var startTimeDict: [DayOfWeek: Date] = {
        guard let days = User.main.regularSchedule?.getDays() else {
            return [:]
        }

        return days.reduce(into: [DayOfWeek: Date]()) { partialResult, day in
            partialResult[day] = .nineAM
        }

    }()

    @Published var endTimeDict: [DayOfWeek: Date] = {
        guard let days = User.main.regularSchedule?.getDays() else {
            return [:]
        }

        return days.reduce(into: [DayOfWeek: Date]()) { partialResult, day in
            partialResult[day] = .fivePM
        }

    }()

    @Published var lastStart: Date = .nineAM
    @Published var lastEnd: Date = .fivePM

    static var shared: RegularDaysContainer = .init()

    func hasDay(_ day: DayOfWeek) -> Bool {
        regularDays.contains(where: { $0.getDayOfWeek() == day })
    }

    func selectedHasDay(_ day: DayOfWeek) -> Bool {
        daysOfWeekSelected.contains(where: { $0 == day })
    }

    func handleDayOfWeek(_ day: DayOfWeek) {
        var set = Set(daysOfWeekSelected)
        if set.contains(day) {
            set.remove(day)
            startTimeDict.removeValue(forKey: day)
            endTimeDict.removeValue(forKey: day)
        } else {
            set.insert(day)
            startTimeDict[day] = .nineAM
            endTimeDict[day] = .fivePM
        }
        daysOfWeekSelected = Array(set)
        daysOfWeekSelected = set.sorted(by: { $0.dayNum < $1.dayNum })
    }

    private func removeDuplicates() {
        daysOfWeekSelected = Set(daysOfWeekSelected).sorted(by: { $0.dayNum < $1.dayNum })
    }

    func addStart(time: Date, for day: DayOfWeek) {
        removeDuplicates()
        startTimeDict[day] = time
        lastStart = time
    }

    func addEnd(time: Date, for day: DayOfWeek) {
        removeDuplicates()
        endTimeDict[day] = time
        lastEnd = time
    }

    func finalizeAndSave(user: User, context: NSManagedObjectContext) throws {
        let regularDays: [RegularDay] = daysOfWeekSelected.map { dayOfWeek in

            let regularDay = RegularDay(dayOfWeek: dayOfWeek,
                                        startTime: startTimeDict[dayOfWeek] ?? .nineAM,
                                        endTime: endTimeDict[dayOfWeek] ?? .fivePM,
                                        user: user,
                                        context: context)

            return regularDay
        }

        try RegularSchedule(days: regularDays, user: user, context: context)
    }
}

// MARK: - SelectDaysView

struct SelectDaysView: View {
    @ObservedObject private var user = User.main

    @StateObject private var daysContainer = RegularDaysContainer.shared

    var body: some View {
        Form {
            Section {
                ForEach(DayOfWeek.orderedCases) { day in
                    Text(day.rawValue)
                        .spacedOut {
                            if daysContainer.selectedHasDay(day) {
                                Image(systemName: "checkmark")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                        .allPartsTappable()
                        .onTapGesture {
                            daysContainer.handleDayOfWeek(day)
                        }
                }
            } header: {
                Text("Days")
                    .hidden()
            }
        }
        .putInTemplate()
        .navigationTitle("Create Schedule")
        .safeAreaInset(edge: .bottom) {
            if daysContainer.daysOfWeekSelected.isEmpty == false {
                NavigationLink {
                    SetHoursForRegularDaysView(daysContainer: daysContainer)
                } label: {
                    BottomButtonView(label: "Next")
                }
            }
        }
    }
}

// MARK: - SelectDaysView_Previews

struct SelectDaysView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDaysView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
