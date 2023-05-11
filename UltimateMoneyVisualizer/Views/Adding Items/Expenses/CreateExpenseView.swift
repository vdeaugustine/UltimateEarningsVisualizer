//
//  CreateExpenseView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - CreateExpenseView

struct CreateExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = "Test expense"
    @State private var amount: String = "39.21"
    @State private var info: String = "this is a test description"
    @State private var dueDate: Date = Date()

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    var body: some View {
        Form {
            Section(header: Text("Expense Information")) {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Info", text: $info)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
        }
        .putInTemplate()
        .navigationTitle("New Expense")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }
        .bottomButton(label: "Save") {
            // Create a new expense object and save it to Core Data

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
                let expense = Expense(context: viewContext)
                expense.title = title
                expense.amount = dub
                expense.info = info
                expense.dueDate = dueDate

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

// MARK: - CreateExpenseView_Previews

struct CreateExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExpenseView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
