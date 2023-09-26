//
//  SelectCalendarForSettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/14/23.
//

import EventKit
import SwiftUI

// MARK: - SelectCalendarForSettingsView

struct SelectCalendarForSettingsView: View {
    @State private var calendarAccessStatus: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)

    @State private var calendars: [EKCalendar] = []
    @State private var selectedCalendars: [EKCalendar] = []
    @ObservedObject private var settings = User.main.getSettings()

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showSuccessAlert: Bool = false

    @State private var includeCalendars: Bool = User.main.getSettings().includeCalendars

    @Environment(\.dismiss) private var dismiss

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack {
            if calendarAccessGranted() {
                List {
                    Section {
                        Toggle("Include calendars", isOn: $includeCalendars)

                    } header: {
                        Text("Calendar Settings").hidden()
                    } footer: { Text("Calendars are automatically synced to create TimeBlock items for your new and current shifts, eliminating the need for manual entry.")
                    }

                    if includeCalendars && calendarAccessGranted() {
                        mainView
                    }
                }

                .putInTemplate(title: "Calendars")
                .task {
                    fetchCalendars()
                }
                .toolbarSave {
                    do {
                        try settings.saveCalendars(selectedCalendars)
                        settings.includeCalendars = includeCalendars
                        try viewContext.save()
                        showSuccessAlert.toggle()
                    } catch {
                        showAlert = true
                        alertMessage = error.localizedDescription
                    }
                }
                //        .onChange(of: selectedCalendars, perform: { _ in
                //            do {
                //                try settings.saveCalendars(selectedCalendars)
                //            } catch {
                //                showAlert = true
                //                alertMessage = error.localizedDescription
                //            }
                //        })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(title: Text("Success"), message: Text("Calendar settings saved successfully"), dismissButton: .default(Text("OK"), action: {
                        dismiss()
                    }))
                }
            } else {
                noAccessToCalendarsView
            }
        }
    }

    var noAccessToCalendarsView: some View {
        VStack(spacing: 40) {
            Text("Allow access to calendars?")
                .font(.system(.title2, weight: .bold))

            Text("To automatically generate Time Blocks from your calendar events, you'll need to allow calendar access in your iOS Settings. Here's how:")
                .multilineTextAlignment(.center)

            VStack(alignment: .leading) {
                HStack {
                    Text("1.")
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.red)
                        .font(.title2)
                    Text("Tap \"Ultimate Money Visualizer\"")
                }

                HStack {
                    Text("2.")
                    staticToggleView
                    Text("Turn \"Calendars\" on")
                }
            }

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            } label: {
                Text("Open iOS Settings")
//                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(16, 8)
                    .background {
                        Color.black.clipShape(Capsule(style: .continuous))
                    }
            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 30)
        .padding(.top, 38)
    }

    func calendarAccessGranted() -> Bool {
        if #available(iOS 17.0, *) {
            return calendarAccessStatus == .fullAccess
        } else {
            return calendarAccessStatus == .authorized
        }
    }

    var mainView: some View {
        Section {
            ForEach(calendars, id: \.self) { calendar in
                Button {
                    selectedCalendars.insertOrRemove(element: calendar)

                } label: {
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
                            .font(.headline)

                        Spacer()
                    }
                }
            }
        } header: {
            HStack {
                Spacer()
                
                Button("All") {
                    if selectedCalendars.isEmpty {
                        selectedCalendars = calendars
                    } else {
                        selectedCalendars.removeAll()
                    }
                }
            }
        }
    }

    private func fetchCalendars() {
        calendars = EKEventStore().calendars(for: .event)
        selectedCalendars = settings.getCalendars()
    }

    private var staticToggleView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green)
                .frame(width: 28, height: 16)
                .overlay(
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.white)
//                            .offset(x: 10)
//                            .frame(width: 29, height: 20)
                            .padding(1)
                    }
                )
        }
    }
}

// MARK: - SelectCalendarForSettingsView_Previews

// struct CustomToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        Toggle("", isOn: configuration.$isOn)
//            .frame(width: 60, height: 2) // Adjust width and height as needed
//    }
// }

struct SelectCalendarForSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCalendarForSettingsView()
    }
}
