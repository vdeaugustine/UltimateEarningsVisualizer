//
//  NewShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/28/23.
//

import SwiftUI
import Vin

// MARK: - NewShiftView

struct NewShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDates: [Date] = []
    @State private var selectedDateComponents: Set<DateComponents> = []
    @State private var startTime: Date = .nineAM
    @State private var endTime: Date = .fivePM
    @State private var chooseByRange = true
    @State private var chooseIndividually = false
    @State private var rangeStartDay = Date.now
    @State private var rangeEndDay = Date.now.addDays(5)

    @State private var expandShiftCircles = false

    @ObservedObject private var user = User.main
    @Environment(\.managedObjectContext) private var viewContext

    @State private var overlappingShiftsAlert: Error? = nil
    @State private var showErrorAlert = false

//    @State private var rangeStartTime: Date = .nineAM
//    @State private var rangeEndTime: Date = .fivePM

    @State private var daysOfTheWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday]

    @State private var scrollHeightForRange: CGFloat = 500

    var body: some View {
        Form {
            if chooseIndividually {
                chooseIndividuallyView
            } else if chooseByRange {
                chooseByRangeView
            }

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
        .onAppear(perform: {
            selectedDateComponents = dates(from: rangeStartDay,
                                           to: rangeEndDay,
                                           matching: daysOfTheWeek)
        })
        .navigationTitle("New Shifts")
        .putInTemplate()
        .bottomButton(label: "Save") {
            let selectedStartComponent = Calendar.current.dateComponents([.hour, .minute], from: startTime)
            let selectedEndComponent = Calendar.current.dateComponents([.hour, .minute],
                                                                       from: endTime)
            do {
                for components in selectedDateComponents {
                    var startComponent = components
                    startComponent.hour = selectedStartComponent.hour
                    startComponent.minute = selectedStartComponent.minute

                    var endComponent = components
                    endComponent.hour = selectedEndComponent.hour
                    endComponent.minute = selectedEndComponent.minute

                    if let thisStartDate = Calendar.current.date(from: startComponent),
                       let thisEndDate = Calendar.current.date(from: endComponent) {
                        try Shift(day: .init(date: thisStartDate),
                                  start: thisStartDate,
                                  end: thisEndDate,
                                  user: user,
                                  context: viewContext)

                    } else {
                        fatalError("Couldn't make dates for shift")
                    }
                }

                try viewContext.save()
                dismiss()
            } catch {
                overlappingShiftsAlert = error
            }
        }
    }

    private var chooseIndividuallyView: some View {
        Section {
            MultiDatePicker("Select dates", selection: $selectedDateComponents)

            DatePicker("Start time", selection: $startTime, displayedComponents: [.hourAndMinute])

            DatePicker("EndTime", selection: $endTime, displayedComponents: [.hourAndMinute])

            if selectedDateComponents.count > 0 {
                ShiftGrid(dateComponents: selectedDateComponents)
            }
        } header: {
            Text("Select Shifts").hidden()
        } footer: {
            if selectedDateComponents.count > 2 {
                Text("All \(selectedDateComponents.count) of these dates selected will have the same start time and end time")
            } else if selectedDateComponents.count == 2 {
                Text("Both of these dates selected will have the same start time and end time")
            }
        }
    }

    @ViewBuilder private var chooseByRangeView: some View {
        Section("Days to Include") {
            ForEach(DayOfWeek.orderedCases) { day in
                Text(day.rawValue.capitalized)
                    .spacedOut(otherView: {
                        if daysOfTheWeek.contains(day) {
                            Image(systemName: "checkmark")
                        }
                    })
                    .allPartsTappable(alignment: .leading)
                    .onTapGesture {
                        daysOfTheWeek.insertOrRemove(element: day)
                        daysOfTheWeek.sort(by: { $0.dayNum < $1.dayNum })
                        selectedDateComponents = dates(from: rangeStartDay, to: rangeEndDay, matching: daysOfTheWeek)
                    }
            }
        }

        Section("Times for Each Day") {
            DatePicker("Start", selection: $startTime, displayedComponents: .hourAndMinute)
            DatePicker("End", selection: $endTime, displayedComponents: .hourAndMinute)
        }

        Section("Date Range") {
            DatePicker("From", selection: $rangeStartDay, displayedComponents: .date)
                .onChange(of: rangeStartDay) { newValue in
                    selectedDateComponents = dates(from: newValue, to: rangeEndDay, matching: daysOfTheWeek)
                    print("New components", selectedDateComponents)
                }

            DatePicker("To", selection: $rangeEndDay, displayedComponents: .date)
                .onChange(of: rangeEndDay) { newValue in
                    selectedDateComponents = dates(from: rangeStartDay, to: newValue, matching: daysOfTheWeek)
                    print("New components", selectedDateComponents)
                }
        }

        if selectedDateComponents.count > 0 {
            Section {
                HStack {
                    Text("\(selectedDateComponents.count) dates selected")
                    Spacer()
                    Button {
                        withAnimation {
                            expandShiftCircles.toggle()
                        }
                    } label: {
                        Components.nextPageChevron.rotationEffect(.degrees(expandShiftCircles ? 90 : -90))
                    }
                }

                if expandShiftCircles {
                    VStack(alignment: .leading) {
                        ShiftGrid(dateComponents: selectedDateComponents)
                    }
                }
            } header: {
                Text("Shifts")
            }
//            VStack {

//            }
            // Adjust the multiplier as needed

//            .frame(height: (CGFloat(max(1, selectedDateComponents.count / 5)) * 50) + 12)

//            .onPreferenceChange(GridHeightPreferenceKey.self, perform: { value in
//                scrollHeightForRange = value.height
//                print("Changed scrollheightz", value)
//            })
        }
    }

    func dates(from startDate: Date,
               to endDate: Date,
               matching daysOfWeek: [DayOfWeek]) -> Set<DateComponents> {
        var dates = Set<DateComponents>()
        var date = startDate

        while date <= endDate {
            let dayOfWeek = DayOfWeek(date: date)
            if daysOfWeek.contains(dayOfWeek) {
                dates.insert(Calendar.current.dateComponents([.year, .month, .day], from: date))
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }

        return dates
    }

    // MARK: - ShiftGrid

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
//            GeometryReader { geo in
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5), spacing: 16) {
                ForEach(sortedDates, id: \.self) { dateComponent in
                    ShiftCircle(dateComponent: dateComponent)
                }

//                    Section {
//                        HStack {
//                        }
//                    }
            }
            .frame(maxHeight: .infinity, alignment: .center)
//                .preference(key: GridHeightPreferenceKey.self, value: geo.frame(in: .global))
//            }
        }
    }

    // MARK: - Preference Keys

    struct GridHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

// MARK: - NewShiftView_Previews

struct NewShiftView_Previews: PreviewProvider {
    static var previews: some View {
        NewShiftView()
            .putInNavView(.inline)
    }
}

