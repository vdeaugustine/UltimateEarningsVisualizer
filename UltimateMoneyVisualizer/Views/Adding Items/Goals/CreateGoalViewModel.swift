//
//  CreateGoalViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/22/23.
//

import AlertToast
import SwiftUI

class CreateGoalViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: String = ""
    @Published var info: String = ""
    @Published var dueDate: Date = Date()
    @Published var amountDouble: Double = 0

    @Published var showToast = false
    @Published var alertToastConfig = AlertToast(displayMode: .hud,
                                                 type: .regular,
                                                 title: "")
    @Published var showEditDoubleSheet = false

    let user = User.main
    let viewContext = User.main.getContext()

    func saveGoal() {
        guard !title.isEmpty else {
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(.blue),
                                          title: "Title must not be empty")
            showToast = true
            return
        }
        guard let dub = Double(amount) else {
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(.blue),
                                          title: "Please enter a valid amount")
            showToast = true
            return
        }

        do {
            try Goal(title: title,
                     info: info,
                     amount: dub,
                     dueDate: dueDate,
                     user: user,
                     context: viewContext)

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
