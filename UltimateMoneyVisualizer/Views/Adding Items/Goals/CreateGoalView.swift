//
//  CreateGoalView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

// MARK: - CreateGoalView

struct CreateGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var info: String = ""
    @State private var dueDate: Date = Date()
    @State private var amountDouble: Double = 0

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    @ObservedObject private var user = User.main

    @State private var showEditDoubleSheet = false

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(amountDouble.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(user.getSettings().getDefaultGradient())
                }
                .allPartsTappable(alignment: .leading)
                .onTapGesture {
                    showEditDoubleSheet.toggle()
                }
                TextField("Info", text: $info)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            } header: {
                Text("Goal Information")
            } footer: {
                Text("Tap on a recent goal to create a new instance of that same goal")
            }
            
            Section("Recent Goals") {
                ForEach(user.getGoals().sorted(by: {$0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now})) { goal in
                    HStack {
                        Text(goal.titleStr)
                        Spacer()
                        Text(goal.dateCreated?.getFormattedDate(format: .slashDate) ?? "")
                    }
                    .allPartsTappable(alignment: .leading)
                    .onTapGesture {
                        title = goal.titleStr
                        amountDouble = goal.amount
                        info = goal.info ?? ""
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("New Goal")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }

        .sheet(isPresented: $showEditDoubleSheet, content: {
            EnterMoneyView(dubToEdit: $amountDouble)
        })

        .bottomButton(label: "Save") {
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
                try Goal(title: title, info: info, amount: dub, dueDate: dueDate, user: user, context: viewContext)

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

// MARK: - CreateGoalView_Previews

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
