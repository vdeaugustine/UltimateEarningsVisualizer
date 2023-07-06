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
    @State private var amount: String = ""
    @State private var info: String = ""
    @State private var date: Date = Date()

    // Alert toast state variables
    @State private var showToast = false
    @State private var alertToastConfig = emptyToast

    @ObservedObject var settings = User.main.getSettings()

    static let emptyToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    @State private var toastType = "s"

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

                    guard let dub = Double(amount),
                          dub > 0 else {
                        alertToastConfig = AlertToast(displayMode: .alert,
                                                      type: .error(settings.themeColor),
                                                      title: "Please enter a valid amount",
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
                        try Saved(amount: dub, title: title,
                                  info: info.isEmpty ? nil : info,
                                  date: date, user: User.main,
                                  context: viewContext)

                        // Reset the fields
                        title = ""
                        amount = "0.0"
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
            amount = "\(newItemViewModel.dubValue)"
        })
        

    }
}

// MARK: - CreateSavedView_Previews

struct CreateSavedView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSavedView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
