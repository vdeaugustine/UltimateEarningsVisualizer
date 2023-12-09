//
//  TestingEventKit.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/12/23.
//

import EventKit
import SwiftUI

extension EKRecurrenceRule {
    func parsedString() -> String {
        var recurrenceInfo = "Recurs: "

        switch frequency {
            case .daily:
                recurrenceInfo += "Daily"
            case .weekly:
                recurrenceInfo += "Weekly"
            case .monthly:
                recurrenceInfo += "Monthly"
            case .yearly:
                recurrenceInfo += "Yearly"
            @unknown default:
                recurrenceInfo += "Unknown"
        }

        let interval = self.interval
//        if interval > 1 {
            recurrenceInfo += " every \(interval) periods"
//        }

        if let daysOfTheWeek = daysOfTheWeek {
            let dayNames = daysOfTheWeek.map { String(describing: $0.dayOfTheWeek) }
            recurrenceInfo += ", Days: \(dayNames.joined(separator: ", "))"
        }

        if let endDate = recurrenceEnd?.endDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            recurrenceInfo += ", Ends on \(formatter.string(from: endDate))"
        }

        return recurrenceInfo
    }
}

// MARK: - TestingEventKit

struct TestingEventKit: View {
    @State private var events: [EKEvent] = []
    @State private var eventItems: [EventItem] = []
    @State private var calendars: [EKCalendar] = []
    @State private var selectedCalendars: [EKCalendar] = []
    @State private var expandedEvent: EKEvent? = nil
    @State private var expandCalendars = true

    @State private var selectedEventItems: [EKEvent] = []

    var body: some View {
        List {
            
            Section("Existing") {
                ForEach(User.main.getRecurringTimeBlocks()) { item in
                    HStack {
                        Components.coloredBar(item.getColor())
                        VStack {
                            Text(item.title ?? "NO TITLE ERROR")
                            if let recurrenceRule = item.getRecurrenceRule() {
                                Text(recurrenceRule.parsedString())
    //                            Text(item.recurrenceRule.parsedString())
                            } else {
                                Text("SOMETHIGN WRONG")
                            }
                            
                        }
                    }
                    
                }
            }
            
            Section(header: Text("Calendars")) {
                HStack {
                    Text("\(selectedCalendars.count) selected")
                    Spacer()
                    Components.nextPageChevron
                        .rotationEffect(.degrees(expandCalendars ? 90 : 0))
                }
                .onTapGesture {
                    withAnimation {
                        expandCalendars.toggle()
                    }
                }

                if expandCalendars {
                    ForEach(calendars, id: \.self) { calendar in
                        Button(action: {
                            
                            if selectedCalendars.firstIndex(where: { thisCal in
                                thisCal == calendar
                            }) != nil {
                                selectedCalendars.removeAll(where: { $0 == calendar })
                            } else {
                                selectedCalendars.append(calendar)
                            }
//                            if selectedCalendars.contains(calendar) {
//                                selectedCalendars.remove(calendar)
//                            } else {
//                                selectedCalendars.insert(calendar)
//                            }
                        }) {
                            HStack {
                                if selectedCalendars.contains(calendar) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }

                                Components.coloredBar(Color(cgColor: calendar.cgColor))

                                Text(calendar.title)
                            }
                        }
                    }
                }
            }
//            when a row is tapped, have it expand downwards and show the events

            ForEach(events.sorted(by: { $0.title < $1.title }), id: \.self) { event in

                HStack {
                    if selectedEventItems.contains(event) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                    Components.coloredBar(Color(cgColor: event.calendar.cgColor))
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                        Text(event.calendar.title)
                            .font(.subheadline)

                        if expandedEvent == event {
                            
                            
                            Text("Start Date: \(event.startDate)")
                                .font(.subheadline)
                            Text("End Date: \(event.endDate)")
                                .font(.subheadline)
                            if let recurrenceRule = event.recurrenceRules?.first {
                                Text("Recurrence: \(recurrenceRule.parsedString())")
                                    .font(.subheadline)
                            }

                            Text("Event Identifier: \(event.eventIdentifier)")
                                .font(.subheadline)
                            Text("All Day: \(event.isAllDay ? "Yes" : "No")")
                                .font(.subheadline)
                            if let alarms = event.alarms {
                                ForEach(alarms, id: \.self) { alarm in
                                    Text("Alarm: \(alarm.description)")
                                        .font(.subheadline)
                                }
                            }
                            if let attendees = event.attendees {
                                ForEach(attendees, id: \.self) { attendee in
                                    Text("Attendee: \(attendee.name ?? "Unknown")")
                                        .font(.subheadline)
                                }
                            }
                            Text("Has Recurrence Rules: \(event.hasRecurrenceRules ? "Yes" : "No")")
                                .font(.subheadline)
                            Text("Calendar: \(event.calendar.title)")
                                .font(.subheadline)
                        }
                    }

                    Spacer()

//                    if let repeats = event.repeats {
//                        HStack {
//                            Text("Repeats")
//                            VStack {
//                                ForEach(repeats, id: \.self) { recurrenceRule in
//                                    Text(recurrenceRule.parsedString())
//                                }
//                            }
//                        }
//                    }
                }
                .onTapGesture {
                    if selectedEventItems.firstIndex(where: { thisEvent in
                        thisEvent == event
                    }) != nil {
                        selectedEventItems.removeAll(where: { $0 == event })
                    } else {
                        selectedEventItems.append(event)
                    }
//                    if selectedEventItems.contains(event) {
//                        selectedEventItems.remove(event)
//                    } else {
//                        selectedEventItems.insert(event)
//                    }
                }

                .onLongPressGesture {
                    if expandedEvent == event {
                        expandedEvent = nil
                    } else {
                        expandedEvent = event
                    }
                }

//                Text("\(event.date)")
//                VStack {
//                    Text(event.title)
//                    Spacer()
//                    Text(String(describing: event.recurrenceRule?.frequency))
//                }
            }
        }
        .refreshable {
            fetchCalendarEvents()
            fetchCalendars()
        }
        .onAppear {
            fetchCalendarEvents()
            fetchCalendars()
        }
        .onChange(of: selectedCalendars, perform: { _ in
            fetchCalendars()
            fetchCalendarEvents()
        })

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Next") {
                    CreateTimeBlocksFromCalendarEventsView(events: events)
                }
            }
        }
        
        .navigationTitle("Generate time blocks")
    }

    func fetchCalendarEvents() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            loadEvents(eventStore: eventStore)
            
        case .notDetermined:
            eventStore.requestAccess(to: .event) { granted, _ in
                if granted {
                    loadEvents(eventStore: eventStore)
                } else {
                    // Handle when access is denied
                    print("Access to calendar was denied.")
                }
            }
            
        case .restricted:
            // Handle restricted access
            print("Access to calendar is restricted.")
            
        case .denied:
            // Handle denied access
            print("Access to calendar was denied. Please enable it in Settings.")
            
        case .fullAccess:
            loadEvents(eventStore: eventStore)
            
        case .writeOnly:
            // Handle write-only access
            print("The app has write-only access to calendar events.")
            
        @unknown default:
            // Handle other cases
            print("An unknown authorization status was encountered.")
        }
    }

    func loadEvents(eventStore: EKEventStore) {
        var identifiers = Set<String>()
        var uniqueEvents = [EKEvent]()

        if !selectedCalendars.isEmpty {
            let startDate = Date()
            let endDate = Calendar.current.date(byAdding: .year, value: 5, to: startDate)!

            let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: Array(selectedCalendars))
            let allEvents = eventStore.events(matching: predicate)

            let recurringEvents = allEvents.filter { $0.hasRecurrenceRules }

            for event in recurringEvents {
                if !identifiers.contains(event.eventIdentifier) {
                    uniqueEvents.append(event)
                    identifiers.insert(event.eventIdentifier)
                }
            }
        }

        events = uniqueEvents

        let eventItems = uniqueEvents.map { EventItem(event: $0) }
        self.eventItems = eventItems
    }

    func repeatFrequencyString(for event: EKEvent) -> String {
        guard let recurrenceRule = event.recurrenceRules?.first else {
            return ""
//            return event.recurrenceRules!.reduce("", { partialResult, rule in
//                partialResult + "\(rule)"
//            })
        }

        switch recurrenceRule.frequency {
            case .daily:
                return "Daily"
            case .weekly:
                return "Weekly"
            case .monthly:
                return "Monthly"
            case .yearly:
                return "Yearly"
            default:
                return "Custom"
        }
    }

    private func fetchCalendars() {
        calendars = EKEventStore().calendars(for: .event)
    }

    struct EventItem: Equatable, Hashable {
//        let eventIdentifier: String // Added eventIdentifier property
        let title: String
//        let date: Date
//        let recurrenceRule: EKRecurrenceRule?
//        let endDate: Date
        let calendarTitle: String
        let calendarColor: CGColor
        let repeats: [EKRecurrenceRule]?

        init(event: EKEvent) {
//            self.eventIdentifier = event.eventIdentifier // Assigned eventIdentifier
            self.title = event.title
            self.calendarTitle = event.calendar.title
            self.calendarColor = event.calendar.cgColor
            self.repeats = event.recurrenceRules

//            self.date = event.startDate
//            self.recurrenceRule = event.recurrenceRules?.first
//            self.endDate = event.endDate
        }
    }
}

// MARK: - TestingEventKit_Previews

struct TestingEventKit_Previews: PreviewProvider {
    static var previews: some View {
        TestingEventKit()
            .putInNavView(.large)
    }
}
