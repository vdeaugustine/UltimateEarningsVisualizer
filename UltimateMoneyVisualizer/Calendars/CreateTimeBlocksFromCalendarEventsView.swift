//
//  CreateTimeBlocksFromCalendarEventsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/14/23.
//

import EventKit
import SwiftUI

// MARK: - CreateTimeBlocksFromCalendarEventsView

struct CreateTimeBlocksFromCalendarEventsView: View {
    let events: [EKEvent]

    var body: some View {
        List {
            ForEach(events.sorted(by: { $0.title < $1.title }), id: \.self) { event in

                HStack {
                    Components.coloredBar(Color(cgColor: event.calendar.cgColor))
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                        Text(event.calendar.title)
                            .font(.subheadline)
                    }

                    Spacer()
                }
            }

            Button("Generate") {
                for event in events {
                    try! RecurringTimeBlock(event: event, user: User.main)
                }
            }
        }
    }
}

// MARK: - CreateTimeBlocksFromCalendarEventsView_Previews

struct CreateTimeBlocksFromCalendarEventsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTimeBlocksFromCalendarEventsView(events: [])
    }
}
