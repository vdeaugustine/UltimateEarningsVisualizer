//
//  FirstPayoffItemView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/13/23.
//

import SwiftUI

// MARK: - GoalOrExpenseView

struct GoalOrExpenseView: View {
    @Binding var chosenType: FirstPayoffItemView_Deprecated.GoalOrExpense?

    var body: some View {
        VStack {
            Button(action: {
                chosenType = .goal
            }) {
                Text("Create a goal")
            }
            Button(action: {
                chosenType = .expense
            }) {
                Text("Create an expense")
            }
        }
    }
}

// MARK: - FirstGoalView

struct FirstGoalView: View {
    @State private var title = ""
    @State private var info = ""
    @State private var date: Date = .now
    @State private var amount: Double = 5

    @State private var titlePopover = false
    @State private var infoPopover = false
    @State private var datePopover = false
    @State private var amountPopover = false

    @FocusState var titleFocused: Bool
    @FocusState var infoFocused: Bool

    @ObservedObject private var settings = User.main.getSettings()

    @State private var showEnterAmountSheet = false

    var body: some View {
        Form {
            Section("Title") {
                TextField("Enter your goal title", text: $title)
                    .focused($titleFocused)
                    .defaultPopover(isPresented: $titlePopover, text: "What is your goal?", direction: .up)
            }

            Section("Info") {
                TextEditor(text: $info)
                    .placeholder("Enter more information about your goal",
                                 text: $info)
                    .focused($infoFocused)
                    .offset(x: -4)
                    .defaultPopover(isPresented: $infoPopover, text: "Now put a little more information\nor a note to yourself about this goal.", direction: .up)
            }

            Section("Date") {
                DatePicker("Goal date", selection: $date)
                    .defaultPopover(isPresented: $datePopover, text: "Set a date to keep track of your goal", direction: .up)
            }

            Section("Amount") {
                Button {
                    showEnterAmountSheet.toggle()
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign",
                                                        backgroundColor: settings.themeColor)
                        Text(amount.money().replacingOccurrences(of: "$", with: ""))
                            .boldNumber()
                        Spacer()
                        Text("Edit")
                    }
                    .allPartsTappable()
                    .foregroundStyle(Color.black)
                }
                .defaultPopover(isPresented: $amountPopover, text: "Finally, enter the amount for your goal!", direction: .up)
            }
        }
        .onAppear(perform: {
            // This is necessary to give the view loading in time to get ready to show the popover
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                titlePopover = true
            }
        })
        .onChangeProper(of: titlePopover) {
            if titlePopover == false {
                titleFocused = true
            }
        }
        .onChangeProper(of: titleFocused) {
            if titleFocused == false {
                infoPopover = true
            }
        }
        .onChangeProper(of: infoPopover) {
            if infoPopover == false {
                infoFocused = true
            }
        }
        .onChangeProper(of: infoFocused) {
            if infoFocused == false {
                datePopover = true
            }
        }
        .onChangeProper(of: datePopover) {
            if datePopover == false {
                amountPopover = true
            }
        }
        .onChangeProper(of: amountPopover) {
            if amountPopover == false {
                showEnterAmountSheet = true
            }
        }
        .dismissKeyboardOnTap(focusStates: [$titleFocused, $infoFocused])
        .sheet(isPresented: $showEnterAmountSheet, content: {
            EnterDoubleView(dubToEdit: $amount, format: .dollar)
        })
    }
}

// MARK: - FirstExpenseView

struct FirstExpenseView: View {
    @State private var title = ""
    @State private var info = ""
    @State private var date: Date = .now
    @State private var amount: Double = 5

    @State private var titlePopover = false
    @State private var infoPopover = false
    @State private var datePopover = false
    @State private var amountPopover = false

    @FocusState var titleFocused: Bool
    @FocusState var infoFocused: Bool

    @ObservedObject private var settings = User.main.getSettings()

    @State private var showEnterAmountSheet = false

    var body: some View {
        Form {
            Section("Title") {
                TextField("Enter your expense title", text: $title)
                    .focused($titleFocused)
                    .defaultPopover(isPresented: $titlePopover, text: "What is your expense?", direction: .up)
            }

            Section("Info") {
                TextEditor(text: $info)
                    .placeholder("Enter more information about your expense",
                                 text: $info)
                    .focused($infoFocused)
                    .offset(x: -4)
                    .defaultPopover(isPresented: $infoPopover, text: "Now put a little more information\nor a note to yourself about this expense.", direction: .up)
            }

            Section("Date") {
                DatePicker("Expense date", selection: $date)
                    .defaultPopover(isPresented: $datePopover, text: "Set a date to keep track of your expense", direction: .up)
            }

            Section("Amount") {
                Button {
                    showEnterAmountSheet.toggle()
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign",
                                                        backgroundColor: settings.themeColor)
                        Text(amount.money().replacingOccurrences(of: "$", with: ""))
                            .boldNumber()
                        Spacer()
                        Text("Edit")
                    }
                    .allPartsTappable()
                    .foregroundStyle(Color.black)
                }
                .defaultPopover(isPresented: $amountPopover, text: "Finally, enter the amount for your goal!", direction: .up)
            }
        }
        .onChangeProper(of: titlePopover) {
            if titlePopover == false {
                titleFocused = true
            }
        }
        .onChangeProper(of: titleFocused) {
            if titleFocused == false {
                infoPopover = true
            }
        }
        .onChangeProper(of: infoPopover) {
            if infoPopover == false {
                infoFocused = true
            }
        }
        .onChangeProper(of: infoFocused) {
            if infoFocused == false {
                datePopover = true
                if infoFocused == false {
                    datePopover = true
                }
            }
        }
        .onChangeProper(of: datePopover) {
            if datePopover == false {
                showEnterAmountSheet = true
            }
        }
        .dismissKeyboardOnTap(focusStates: [$titleFocused, $infoFocused])
        .sheet(isPresented: $showEnterAmountSheet, content: {
            EnterDoubleView(dubToEdit: $amount, format: .dollar)
        })
    }
}

// MARK: - FirstPayoffItemView

struct FirstPayoffItemView_Deprecated: View {
    enum GoalOrExpense: String, Identifiable, CaseIterable {
        case goal
        case expense

        var id: String { rawValue }
    }

    @State private var chosenType: GoalOrExpense? = nil

    @ViewBuilder var body: some View {
        if let chosenType {
            switch chosenType {
                case .goal:
                    FirstGoalView()
                case .expense:
                    FirstExpenseView()
            }
        } else {
            GoalOrExpenseView(chosenType: $chosenType)
        }
    }
}

#Preview {
    FirstPayoffItemView_Deprecated()
}
