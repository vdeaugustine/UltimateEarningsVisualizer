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
    @State private var calendars: [EKCalendar] = []
    @State private var selectedCalendars: [EKCalendar] = []
    @ObservedObject private var settings = User.main.getSettings()

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    
    var body: some View {
        List {
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
            
            
            Section("In core data") {
                ForEach(settings.getCalendars(), id: \.self) { calendar in
                    HStack {
                        Components.coloredBar(Color(cgColor: calendar.cgColor))

                        Text(calendar.title)
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                }
            }
        }
        .task {
            fetchCalendars()
        }
        .onChange(of: selectedCalendars, perform: { value in
            do {
                try settings.saveCalendars(selectedCalendars)
            }
            catch {
                showAlert = true
                alertMessage = error.localizedDescription
                
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
    }

    private func fetchCalendars() {
        calendars = EKEventStore().calendars(for: .event)
    }


    


}

// MARK: - SelectCalendarForSettingsView_Previews

struct SelectCalendarForSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCalendarForSettingsView()
    }
}
