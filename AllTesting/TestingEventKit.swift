//
//  TestingEventKit.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/12/23.
//

import EventKit
import SwiftUI

// MARK: - TestingEventKit

struct TestingEventKit: View {
    @State private var events: [EKEvent] = []
    @State private var eventItems: [EventItem] = []

    var body: some View {
        List {
            ForEach(eventItems, id: \.self) { event in
                Text(event.title)
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
        }
        .onAppear {
            fetchCalendarEvents()
        }
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
                    }
                }
            default:
                break
        }
    }

    func loadEvents(eventStore: EKEventStore) {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)

        let allEvents = eventStore.events(matching: predicate)
        let uniqueEvents = Array(Set(allEvents.filter { $0.recurrenceRules != nil }))
        events = uniqueEvents

        let eventItems = uniqueEvents.map { EventItem(event: $0) }
        self.eventItems = Array(Set(eventItems))
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

    struct EventItem: Equatable, Hashable {
//        let eventIdentifier: String // Added eventIdentifier property
        let title: String
//        let date: Date
//        let recurrenceRule: EKRecurrenceRule?
//        let endDate: Date

        init(event: EKEvent) {
//            self.eventIdentifier = event.eventIdentifier // Assigned eventIdentifier
            self.title = event.title
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
    }
}
