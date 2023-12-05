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
    @EnvironmentObject private var newItemViewModel: NewItemViewModel
    @State private var title: String = ""
    @State private var info: String = ""
    @State private var date: Date = Date()
    @State private var doubleAmount: Double = 0

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = emptyToast

    @State private var showEditSheet = false

    @ObservedObject var settings = User.main.getSettings()

    static let emptyToast = AlertToast(displayMode: .hud, type: .regular, title: "")

    @State private var toastType = "s"

    @FocusState private var titleFocused
    @FocusState private var infoFocused
    @FocusState private var dateFocused
    @FocusState private var doubleAmountFocused

    let examples: (title: String, info: String)

    init() {
        self.examples = Saved.getExampleTitleAndDescription()
    }

    var readyToSave: Bool {
        doubleAmount > 0 && !title.isEmpty &&
            !info.isEmpty && !titleFocused && !infoFocused && !dateFocused && !doubleAmountFocused && !showEditSheet
    }

    var body: some View {
        Form {
            Section(header: Text("Title"), footer: Text("How did you save money?")) {
                TextField("Ex: \(examples.title)", text: $title)
                    .focused($titleFocused)
            }

            Section(header: Text("Info (optional)"), footer: Text("Extra details to help you remember this specific scenario.")) {
                TextEditor(text: $info)
                    .placeholder("Ex: \(examples.info)", text: $info)
                    .focused($infoFocused)
//                TextField("Ex: \(examples.info)", text: $info)
            }

            Section(header: Text("Date")) {
                DatePicker("When did you save?", selection: $date, displayedComponents: .date)
                    .focused($dateFocused)
            }

            Section(header: Text("Amount")) {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: newItemViewModel.user.getSettings().themeColor)
                    Text(doubleAmount.money().replacingOccurrences(of: "$", with: ""))
                        .boldNumber()
                    Spacer()
                    Text("Edit")
                }
                .onTapGesture {
                    showEditSheet.toggle()
                    doubleAmountFocused = true
                }
            }
        }
        .putInTemplate()
        .navigationTitle("New Saved Item")
        .toast(isPresenting: $showToast,
               duration: 2.5,
               tapToDismiss: false,
               offsetY: toastType == "s" ? 65 : 0) {
            alertToastConfig
        } onTap: {
            showToast = false
        } completion: {
            alertToastConfig = Self.emptyToast
        }
        .onAppear(perform: {
            doubleAmount = newItemViewModel.dubValue
            titleFocused = true
        })
        .sheet(isPresented: $showEditSheet, content: {
            EnterDoubleView(dubToEdit: $doubleAmount, format: .dollar)
        })
        .conditionalModifier(readyToSave) { mainView in
            mainView
                .bottomButton(label: "Save") {
                    saveAction()
                }
        }

        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if titleFocused {
                    toolbarForTitle()
                }

                if infoFocused {
                    toolbarForInfo()
                }

                if dateFocused {
                    toolbarForDate()
                }

                if doubleAmountFocused {
                    toolbarForDoubleAmount()
                }
            }
        }
    }

    func toolbarForTitle() -> some View {
        HStack {
            Button("Cancel") {
                titleFocused = false
            }
            Spacer()
            Button("Next") {
                titleFocused = false
                infoFocused = true
            }
        }
    }

    func toolbarForInfo() -> some View {
        HStack {
            Button("Back") {
                titleFocused = true
                infoFocused = false
            }
            Spacer()
            Button("Next") {
                infoFocused = false
                dateFocused = true
            }
        }
    }

    func toolbarForDate() -> some View {
        HStack {
            Button("Back") {
                dateFocused = false
                infoFocused = true
            }
            Spacer()
            Button("Next") {
                dateFocused = false
                doubleAmountFocused = true
                showEditSheet.toggle()
            }
        }
    }

    func toolbarForDoubleAmount() -> some View {
        HStack {
            Button("Back") {
                doubleAmountFocused = false
                dateFocused = true
                showEditSheet.toggle()
            }
            Spacer()
            Button("Done") {
                doubleAmountFocused = false
            }
        }
    }

    func saveAction() {
        guard !title.isEmpty else {
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(settings.themeColor),
                                          title: "Title must not be empty",
                                          subTitle: nil,
                                          style: .style(backgroundColor: nil,
                                                        titleColor: nil,
                                                        subTitleColor: nil,
                                                        titleFont: nil,
                                                        subTitleFont: nil))
            showToast = true
            toastType = "e"
            return
        }

        do {
            try Saved(amount: doubleAmount,
                      title: title,
                      info: info.isEmpty ? nil : info,
                      date: date,
                      user: User.main,
                      context: viewContext)

            // Reset the fields
            title = ""
            info = ""
            date = Date()

            alertToastConfig = AlertToast(displayMode: .hud,
                                          type: .complete(settings.themeColor),
                                          title: "Successfully saved",
                                          subTitle: nil,
                                          style: .style(backgroundColor: nil,
                                                        titleColor: nil,
                                                        subTitleColor: nil,
                                                        titleFont: nil,
                                                        subTitleFont: nil))

            toastType = "s"
            showToast = true

        } catch let error {
            // Show an error alert toast
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(settings.themeColor),
                                          title: "Error saving",
                                          subTitle: error.localizedDescription)
            toastType = "e"
            showToast = true
        }
    }
}

// MARK: - CreateSavedView_Previews

struct CreateSavedView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSavedView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .environmentObject(NewItemViewModel())
    }
}


