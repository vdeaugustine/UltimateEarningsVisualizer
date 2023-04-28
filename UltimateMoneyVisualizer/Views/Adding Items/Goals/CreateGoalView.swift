//
//  CreateGoalView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

struct CreateGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = "Go to disneyworld"
    @State private var amount: String = "2000"
    @State private var info: String = "With Noah!"
    @State private var dueDate: Date = Date()

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    var body: some View {
        Form {
            Section(header: Text("Goal Information")) {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Info", text: $info)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }

            Section {
                Button("Save") {
                    // Create a new goal object and save it to Core Data

                    guard !title.isEmpty else {
                        alertToastConfig = AlertToast(displayMode: .alert, type: .error(.blue), title: "Title must not be empty")
                        showToast = true
                        return
                    }
                    guard let dub = Double(amount) else {
                        alertToastConfig = AlertToast(displayMode: .alert, type: .error(.blue), title: "Please enter a valid amount")
                        showToast = true
                        return
                    }

                    do {
                        let goal = Goal(context: viewContext)
                        goal.title = title
                        goal.amount = dub
                        goal.info = info
                        goal.dueDate = dueDate

                        try viewContext.save()

                        // Reset the fields
                        title = ""
                        amount = ""
                        info = ""
                        dueDate = Date()

                        // Show a success alert toast
                        alertToastConfig.title = "Item saved successfully."
                        showToast = true
                    } catch let error {
                        // Show an error alert toast
                        alertToastConfig.title = "Error: \(error.localizedDescription)"
                        showToast = true
                    }
                }
            }
        }
        .navigationTitle("New Goal")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("Goals") {
                    GoalListView()
                }
            }
        }
    }
}

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}

