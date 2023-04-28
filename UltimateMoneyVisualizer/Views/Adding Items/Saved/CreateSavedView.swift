//
//  CreateSavedView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

// MARK: - CreateSavedView

struct CreateSavedView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var title: String = "Didn't go to lunch"
    @State private var amount: String = "10"
    @State private var info: String = "Ate at home"
    @State private var date: Date = Date()

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    var body: some View {
        Form {
            Section(header: Text("Saved Information")) {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Info", text: $info)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Section {
                Button("Save") {
                    // Create a new Saved object and save it to Core Data

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
                        let saved = Saved(context: viewContext)
                        saved.title = title
                        saved.amount = dub
                        saved.info = info
                        saved.date = date

                        try viewContext.save()

                        // Reset the fields
                        title = ""
                        amount = "0.0"
                        info = ""
                        date = Date()

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
        .navigationTitle("New Saved Item")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("Saved Items") {
                    SavedListView()
                }
            }
        }
    }
}

// MARK: - CreateSavedView_Previews

struct CreateSavedView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSavedView()
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}

// MARK: - CurrencyFormatter

//struct CurrencyFormatter: Formatter {
//    let numberFormatter: NumberFormatter = {
//        let nf = NumberFormatter()
//        nf.numberStyle = .currency
//        nf.currencySymbol = "$"
//        return nf
//    }()
//
//    func string(for value: Any?) -> String? {
//        guard let value = value as? Double else { return nil }
//        return numberFormatter.string(from: NSNumber(value: value))
//    }
//
//    func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
//        guard let number = numberFormatter.number(from: string) else { return false }
//        obj?.pointee = number.doubleValue as AnyObject
//        return true
//    }
//}

// MARK: - CreateSavedView_Previews

//struct CreateSavedView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateSavedView()
//    }
//}
