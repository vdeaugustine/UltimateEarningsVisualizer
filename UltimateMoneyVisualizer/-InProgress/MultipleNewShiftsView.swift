//
//  MultipleNewShiftsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/3/23.
//

import SwiftUI
import AlertToast
import Vin

// MARK: - MultipleNewShiftsView

struct MultipleNewShiftsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user: User = User.main
    @ObservedObject private var wage = User.main.getWage()
    @ObservedObject private var settings = User.main.getSettings()
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDates: [Date] = []
    @State private var selectedDateComponents: Set<DateComponents> = []
    @State private var startTime: Date = .nineAM
    @State private var endTime: Date = .fivePM
    @State private var chooseByRange = false
    @State private var chooseIndividually = true
    @State private var rangeStart = Date.now
    @State private var rangeEnd = Date.now.addDays(5)
    
    @State private var showAlertToast = false
    @State private var alertConfiguration = AlertToast(displayMode: .banner(.pop), type: .complete(User.main.getSettings().themeColor), title: "Saved Successfully")

    var body: some View {
        List {
            if chooseIndividually {
                Section {
                    MultiDatePicker("Select dates", selection: $selectedDateComponents)

                    DatePicker("Start time", selection: $startTime, displayedComponents: [.hourAndMinute])

                    DatePicker("EndTime", selection: $endTime, displayedComponents: [.hourAndMinute])
                        .listRowSeparator(.hidden)

                    if selectedDateComponents.count > 0 {
                        ShiftGrid(dateComponents: selectedDateComponents)
                    }
                } header: {
                    Text("Choose dates")
                } footer: {
                    if selectedDateComponents.count > 2 {
                        Text("All \(selectedDateComponents.count) of these dates selected will have the same start time and end time")
                    } else if selectedDateComponents.count == 2 {
                        Text("Both of these dates selected will have the same start time and end time")
                    }
                }
            }
            
//            else if chooseByRange {
//
//                    Section("My Regular Days") {
//                        Text(regularDays.str)
//                    }
//                    Section("Times") {
//                        Text("Start")
//                            .spacedOut(text: normalStart.formattedTime())
//                        Text("End")
//                            .spacedOut(text: normalEnd.formattedTime())
//                    }
//
//                    Section("Create shifts") {
//                        DatePicker("From", selection: $rangeStart, displayedComponents: .date)
//                            .onChange(of: rangeStart) { _ in
//                                shifts = AllShifts.shiftsForNormalWorkDays(between: rangeStart, and: rangeEnd, days: regularDays, start: normalStart, end: normalEnd)
//                            }
//                        DatePicker("To", selection: $rangeEnd, displayedComponents: .date)
//                            .onChange(of: rangeEnd) { _ in
//                                shifts = AllShifts.shiftsForNormalWorkDays(between: rangeStart, and: rangeEnd, days: regularDays, start: normalStart, end: normalEnd)
//                            }
//                    }
//                    .onAppear {
//                        shifts = AllShifts.shiftsForNormalWorkDays(between: rangeStart, and: rangeEnd, days: regularDays, start: normalStart, end: normalEnd)
//                    }
//
//                    Section {
//                        if shifts.count > 0 {
//                            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], spacing: 16) {
//                                ForEach(shifts) { shift in
//                                    ShiftCircle(dateGiven: shift.startTime)
//                                }
//                            }
//                        }
//                    }
//                    .listRowBackground(Color.clear)
//
//                 else {
//                    NavigationLink("Set up regular work hours") {
//                        NormalWorkingHoursView()
//                    }
//                }
//            }

//            if chooseIndividually == false {
//                Section(chooseByRange ? "OR" : "") {
//                    Button("Choose individual days") {
//                        withAnimation {
//                            chooseIndividually = true
//                            chooseByRange = false
//                        }
//                    }
//                }
//            }
//
//            if chooseByRange == false {
//                Section("OR") {
//                    Button("Choose by date range") {
//                        withAnimation {
//                            chooseIndividually = false
//                            chooseByRange = true
//                        }
//                    }
//                }
//            }
        }
        .putInTemplate()
        .navigationTitle("Add Shifts")
        .bottomButton(label: "Save") {
            
                for dateComponent in selectedDateComponents {
                    func dateFromComponents(dc: DateComponents, time: Date) -> Date? {
                        let calendar = Calendar.current
                        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
                        var combinedComponents = dc
                        combinedComponents.hour = timeComponents.hour
                        combinedComponents.minute = timeComponents.minute
                        combinedComponents.second = timeComponents.second
                        return calendar.date(from: combinedComponents)
                    }

                    guard let start = dateFromComponents(dc: dateComponent, time: startTime),
                          let end = dateFromComponents(dc: dateComponent, time: endTime)
                    else {
                        fatalError("Could not find start end time")
                    }
                    
                    do {
                        let shift = Shift(context: viewContext)
                        shift.dayOfWeek = DayOfWeek(date: start).rawValue
                        shift.startDate = start
                        shift.endDate = end
                        shift.user = user
                        
                        try viewContext.save()
                        alertConfiguration = AlertToast(displayMode: .banner(.pop), type: .complete(User.main.getSettings().themeColor), title: "Saved Successfully")
                        print("Saved!")
                        showAlertToast = true
                    }
                    catch {
                        print("error saving", error)
//                        fatalError("Error saving shift in MultipleNewShiftsView")
                    }
                    

//                    let newShift = Shift(startTime: st, endTime: et)
//                    model.allShifts.addShift(newShift)
                }
        }
        .toast(isPresenting: $showAlertToast) {
            alertConfiguration
        }
    }

    struct ShiftGrid: View {
        init(dateComponents: Set<DateComponents>) {
            self.dateComponents = dateComponents
        }

        let dateComponents: Set<DateComponents>
        var sortedDates: [DateComponents] {
            dateComponents.sorted { dateC1, dateC2 in
                guard let date1 = Calendar.current.date(from: dateC1),
                      let date2 = Calendar.current.date(from: dateC2) else {
                    return false
                }
                return date1 < date2
            }
        }

        var body: some View {
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], spacing: 16) {
                ForEach(sortedDates, id: \.self) { dateComponent in
                    ShiftCircle(dateComponent: dateComponent)
                }

                Section {
                    HStack {
                    }
                }
            }
        }
    }
}

// MARK: - MultipleNewShiftsView_Previews

struct MultipleNewShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleNewShiftsView()
            .putInNavView(.inline)
    }
}
