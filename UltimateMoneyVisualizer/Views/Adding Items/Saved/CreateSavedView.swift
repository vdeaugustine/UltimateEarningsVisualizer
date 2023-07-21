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

    var readyToSave: Bool {
        doubleAmount > 0 && !title.isEmpty &&
            !info.isEmpty && !titleFocused && !infoFocused && !showEditSheet
    }

    var body: some View {
        Form {
            Section(header: Text("Saved Information")) {
                TextField("Title", text: $title)
                    .focused($titleFocused)
                TextField("Info", text: $info)
                    .focused($infoFocused)
                DatePicker("Saved on", selection: $date, displayedComponents: .date)
                    .focused($dateFocused)
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: newItemViewModel.user.getSettings().themeColor)
                    Text(doubleAmount.money().replacingOccurrences(of: "$", with: ""))
                        .boldNumber()
                    Spacer()
                    Text("Edit")
                }
                .onTapGesture {
                    showEditSheet.toggle()
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
                        showEditSheet = true
                    }
                }

                if dateFocused {
                    Button("Cancel") {
                        dateFocused = false
                    }
                    Button("Next") {
                        dateFocused = false
                        showEditSheet.toggle()
                    }
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
            .putInNavView(.inline)
            .environmentObject(NewItemViewModel())
    }
}
