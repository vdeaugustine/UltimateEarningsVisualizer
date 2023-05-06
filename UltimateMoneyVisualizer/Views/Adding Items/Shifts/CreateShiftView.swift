//
//  CreateShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI
import Vin
// MARK: - CreateShiftView

struct CreateShiftView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var startDate: Date = .getThisTime(hour: 9, minute: 0)!
    @State private var endDate: Date = .getThisTime(hour: 17, minute: 0)!

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    var duration: TimeInterval {
        abs(endDate - startDate)
    }
    
    var dayOfWeek: DayOfWeek {
        DayOfWeek(date: startDate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Shift Information")) {
                
                DatePicker("Start Time", selection: $startDate)
                DatePicker("End Time", selection: $endDate,  in: startDate ... .distantFuture)
                Text("Duration")
                    .spacedOut(text: duration.formatForTime())
                Text("Day of Week")
                    .spacedOut(text: dayOfWeek.rawValue)
            }

//            Section {
//                Button("Save") {
//
//                }
//            }
            
            Section("Add Multiple Shifts") {
                
                NavigationLink("Add Multiple Shifts") {
                    MultipleNewShiftsView()
                }
                
            }
            
            
        }
        
        .putInTemplate()
        .navigationTitle("New Shift")
        .bottomButton(label: "Save", action: {
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
        })
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

// MARK: - CreateShiftView_Previews

struct CreateShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShiftView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
