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

    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var info: String = ""
    @State private var dueDate: Date = Date()

    @ObservedObject private var user: User = .main

    @State private var doubleAmount: Double = 0

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = AlertToast(displayMode: .hud, type: .regular, title: "")

    @State private var showSheet = false

    @FocusState private var titleFocused
    @FocusState private var infoFocused
    @FocusState private var dateFocused

    var body: some View {
        Form {
            Section(header: Text("Expense Information")) {
                TextField("Title", text: $title)

                    .focused($titleFocused)
                TextField("Info", text: $info)
                    .focused($infoFocused)

                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .focused($dateFocused)
            }

            Section {
                Button {
                    showSheet.toggle()

                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                        Text(doubleAmount.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    }
                }
            }
            header: {
                Text("Amount")
            }
            footer: {
                Text("Tap to edit")
            }
        }
        .putInTemplate()
        .navigationTitle("New Expense")
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            alertToastConfig
        } onTap: {
            showToast = false
        }
        .onAppear(perform: {
            titleFocused = true
        })

        .sheet(isPresented: $showSheet, content: {
            EnterMoneyView(dubToEdit: $doubleAmount)

        })
        .onChange(of: dateFocused, perform: { newValue in
            print("Date is focused: \(newValue.description)")
        })

        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if titleFocused {
                    if !title.isEmpty {
                        Button("Clear") {
                            
                            if titleFocused {
                                title = ""
                            }
                        }
                    } else {
                        Button("Cancel") {
                            titleFocused = false
                        }
                    }

                    Spacer()

                    Button("Next") {
                        infoFocused = true
                    }
                }

                if infoFocused {
                    if !info.isEmpty {
                        Button("Clear") {
                            if infoFocused {
                                info = ""
                            }
                            
                        }
                    } else {
                        Button("Back") {
                            titleFocused = true
                        }
                    }

                    Spacer()

                    Button("Next") {
                        infoFocused = false
                        showSheet.toggle()
                    }
                }
            }
        }

        .toolbarSave {
            guard !title.isEmpty else {
                alertToastConfig = AlertToast(displayMode: .alert, type: .error(.blue), title: "Title must not be empty")
                showToast = true
                return
            }
//            guard let dub = Double(amount) else {
//                alertToastConfig = AlertToast(displayMode: .alert, type: .error(.blue), title: "Please enter a valid amount")
//                print("This is amount: \(amount)")
//                showToast = true
//                return
//            }

            do {
                Expense(title: title, info: info, amount: doubleAmount, dueDate: dueDate, dateCreated: .now, user: user, context: viewContext)

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
            .putInNavView(.inline)
    }
}
