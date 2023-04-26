//
//  CreateShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

struct CreateShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var dayOfWeek: DayOfWeek = .getCurrentDayOfWeek()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    var body: some View {
        Form {
            Section(header: Text("Shift Information")) {
                Picker("Day of Week", selection: $dayOfWeek) {
                    ForEach(DayOfWeek.allCases) { day in
                        Text(day.rawValue)
                            .tag(day)
                    }
                }
                DatePicker("Start Time", selection: $startDate, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $endDate, displayedComponents: .hourAndMinute)
            }

            Section {
                Button("Save") {
                    // Create a new shift object and save it to Core Data

                    let shift = Shift(context: viewContext)
                    shift.dayOfWeek = dayOfWeek.rawValue
                    shift.startDate = startDate
                    shift.endDate = endDate

                    do {
                        try viewContext.save()
                        // Show a success alert toast
                        alertToastConfig.title = "Shift saved successfully."
                        alertToastConfig.type = .regular
                        showToast = true
                    } catch let error {
                        // Show an error alert toast
                        alertToastConfig.title = "Error: \(error.localizedDescription)"
                        alertToastConfig.type = .error(.blue)
                        showToast = true
                    }

                    // Reset the fields
                    startDate = Date()
                    endDate = Date()
                }
            }
        }
        .navigationTitle("New Shift")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("Shifts") {
                    ShiftListView()
                }
            }
        }
    }
}


struct CreateShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShiftView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

