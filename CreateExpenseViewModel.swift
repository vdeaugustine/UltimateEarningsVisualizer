//
//  CreateExpenseViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import AlertToast
import SwiftUI

class CreateExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var info: String = ""
    @Published var dueDate: Date = Date()
    @Published var amountDouble: Double = 0
    @Published var showRecentTags = false
    @Published var showRecentExpenses = false
    @Published var tags: Set<TemporaryTag> = []

    @Published var showToast = false
    @Published var alertToastConfig = AlertToast(displayMode: .hud,
                                                 type: .regular,
                                                 title: "")
    @Published var showEditDoubleSheet = false
    @Published var showNewTagSheet = false

    @ObservedObject var user = User.main
    @ObservedObject private var navManager = NavManager.shared
    let viewContext = User.main.getContext()

    struct TemporaryTag: Hashable, Comparable {
        static func < (lhs: CreateExpenseViewModel.TemporaryTag, rhs: CreateExpenseViewModel.TemporaryTag) -> Bool {
            lhs.title < rhs.title
        }

        var title: String
        var symbolStr: String
        var color: Color

        init(title: String, symbolStr: String, color: Color) {
            self.title = title
            self.symbolStr = symbolStr
            self.color = color
        }

        init(_ realTag: Tag) {
            self.title = realTag.getTitle()
            self.symbolStr = realTag.getSymbolStr()
            self.color = realTag.getColor()
        }
    }
    
    enum FocusedField {
        case title, info
    }

    func saveExpense(amount: String) {
        guard !title.isEmpty else {
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(user.getSettings().themeColor),
                                          title: "Title must not be empty")
            showToast = true
            return
        }
        guard amountDouble > 0 else {
            alertToastConfig = AlertToast(displayMode: .alert,
                                          type: .error(user.getSettings().themeColor),
                                          title: "Please enter an amount over 0")
            print("Amount entered \(amount)")
            showToast = true
            return
        }

        do {
            let expense = try Expense(title: title,
                                info: info,
                                amount: amountDouble,
                                dueDate: dueDate,
                                user: user,
                                context: viewContext)

            let knownTags = user.getTags()
            let newTags = tags.filter { tempTag in
                !knownTags.contains { knownTag in
                    knownTag.getTitle().lowercased().removingWhiteSpaces() == tempTag.title.lowercased().removingWhiteSpaces()
                }
            }

            for tag in newTags {
                try Tag(tag.title,
                        symbol: tag.symbolStr,
                        color: tag.color,
                        expense: expense,
                        user: user,
                        context: user.getContext())
            }

            // Show a success alert toast
            alertToastConfig.title = "Item saved successfully."
            showToast = true
            print("SAVED SUCCESSFULLY!")
            navManager.makeCurrentPath(this: .init([ NavManager.AllViews.expense(expense) ]))
            
        } catch let error {
            // Show an error alert toast
            alertToastConfig.title = "Error: \(error.localizedDescription)"
            showToast = true
            print("There was an error \(error)")
        }
    }
}
