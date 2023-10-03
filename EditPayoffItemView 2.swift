//
//  EditPayoffItemView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/1/23.
//

import SwiftUI

// MARK: - EditPayoffItemView

struct EditPayoffItemView: View {
    let payoffItem: PayoffItem

    @State private var title: String = ""
    @State private var info: String = ""

    @State private var amount: Double = 0

    @State private var date: Date = .now

    @State private var repeatFrequency: RepeatFrequency = .never

    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @FocusState private var goalTitleFocused
    @FocusState private var goalInfoFocused
    @FocusState private var expenseTitleFocused
    @FocusState private var expenseInfoFocused
    

    var body: some View {
        if let goal = payoffItem as? Goal,
           let goalTitle = goal.title,
           let goalInfo = goal.info,
           let goalDate = goal.dueDate {
            Form {
                Section("Title") {
                    TextField(goalTitle, text: $title)
                        .focused($goalTitleFocused)
                }

                Section("Info") {
                    TextEditor(text: $info)
                        .focused($goalInfoFocused)
                }

                Section("Due Date") {
                    DatePicker("Due Date", selection: $date, displayedComponents: .date)
                        .onAppear {
                            date = goalDate
                        }
                }

                Section("Repeat") {
                    Picker("Repeats", selection: $repeatFrequency) {
                        ForEach(RepeatFrequency.allCases) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                            if frequency == .never {
                                Divider()
                            }
                        }
                    }
                }

                Section {
                    Button("Save") {
                        goal.title = title
                        goal.info = info
                        goal.amount = amount
                        goal.dueDate = date
                        goal.repeatFrequency = repeatFrequency.rawValue

                        do {
                            try viewContext.save()
                            showSuccessAlert = true
                        } catch {
                            showErrorAlert = true
                        }
                    }
                }
            }
            .putInTemplate(title: "Edit goal")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Clear") {
                        info = ""
                    }
                    Spacer()

                    Button("Done") {
                        if goalTitleFocused {
                            goalTitleFocused = false
                        }
                        if goalInfoFocused {
                            goalInfoFocused = false
                        }
                    }
                }
            }
            .onAppear(perform: {
                info = goalInfo
            })
            .alert("Error saving changes", isPresented: $showErrorAlert) {} message: {
                Text("Please try again. If issue persists, try restarting the app.")
            }
            .alert("Changes saved successfully", isPresented: $showSuccessAlert) {
                Button("Ok") {
                    dismiss()
                }
            }
        } else if let expense = payoffItem as? Expense,
                  let expenseTitle = expense.title,
                  let expenseInfo = expense.info,
                  let expenseDate = expense.dueDate {
            Form {
                Section("Title") {
                    TextField(expenseTitle, text: $title)
                        .focused($expenseTitleFocused)
                }

                Section("Info") {
                    TextEditor(text: $info)
                        .focused($expenseInfoFocused)
                        .onAppear(perform: {
                            info = expenseInfo
                        })
                }

                Section("Due Date") {
                    DatePicker("Due Date", selection: $date, displayedComponents: .date)
                        .onAppear {
                            date = expenseDate
                        }
                }

                Section("Repeat") {
                    Picker("Repeats", selection: $repeatFrequency) {
                        ForEach(RepeatFrequency.allCases) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                            if frequency == .never {
                                Divider()
                            }
                        }
                    }
                }

                Section {
                    Button("Save") {
                        expense.title = title
                        expense.info = info
                        expense.amount = amount
                        expense.dueDate = date
                        expense.repeatFrequency = repeatFrequency.rawValue

                        do {
                            try viewContext.save()
                            showSuccessAlert = true
                        } catch {
                            showErrorAlert = true
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Clear") {
                        info = ""
                    }

                    Spacer()

                    Button("Done") {
                        if expenseTitleFocused {
                            expenseTitleFocused  = false
                        }
                        if expenseInfoFocused {
                            expenseInfoFocused = false
                        }
                    }
                }
            }
            .putInTemplate(title: "Edit expense")
            .alert("Error saving changes", isPresented: $showErrorAlert) {} message: {
                Text("Please try again. If issue persists, try restarting the app.")
            }
            .alert("Changes saved successfully", isPresented: $showSuccessAlert) {
                Button("Ok") {
                    dismiss()
                }
            }

        } else {
            NoContentPlaceholderCustomView(title: "Error retrieving item",
                                           subTitle: "If issue persists, try restarting the app.",
                                           imageSystemName: "externaldrive.badge.xmark",
                                           buttonTitle: "Go back",
                                           buttonColor: User.main.getSettings().themeColor) {
                NavManager.shared.popFromCorrectPath()
            }
        }
    }
}

// MARK: - EditPayoffItemView_Previews

struct EditPayoffItemView_Previews: PreviewProvider {
    static let user: User = {
        DebugOperations.deleteAll()
        let user = User.main
        user.instantiateExampleItems(context: PersistenceController.context)

        return user
    }()

    static var previews: some View {
//        EditPayoffItemView(payoffItem: user.getGoals().first!)
        EditPayoffItemView(payoffItem: user.getExpenses().first!)
    }
}
