//
//  CreateScheduleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/13/23.
//

import SwiftUI

// MARK: - RegularDaysContainer

public class RegularDaysContainer: ObservableObject {
    @Published var regularDays: [RegularDay] = []

    @Published var daysOfWeekSelected: [DayOfWeek] = []
    
    @Published var startTimeDict: [DayOfWeek: Date] = [:]
    @Published var endTimeDict: [DayOfWeek: Date] = [:]

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
        daysOfWeekSelected = set.sorted(by: { $0.dayNum < $1.dayNum })
    }
    
    private func removeDuplicates() {
        daysOfWeekSelected = Set(daysOfWeekSelected).sorted(by: { $0.dayNum < $1.dayNum })
    }
    
    func addStart(time: Date, for day: DayOfWeek) {
        removeDuplicates()
        startTimeDict[day] = time
    }
    
    func addEnd(time: Date, for day: DayOfWeek) {
        removeDuplicates()
        endTimeDict[day] = time
    }
}

struct SelectDaysView: View {
    
    @ObservedObject private var user = User.main
    
    @ObservedObject private var daysContainer = RegularDaysContainer.shared
    
    
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
            }
        }
        .putInTemplate()
        .navigationTitle("Create Schedule")
        .safeAreaInset(edge: .bottom) {
            if daysContainer.daysOfWeekSelected.isEmpty == false {
                NavigationLink {
                    
                } label: {
                    BottomViewButton(label: "Next")
                }
            }

        }
    }
}

struct SelectDaysView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDaysView()
        .environment(\.managedObjectContext, PersistenceController.context)
        .putInNavView(.inline)
    }
}
