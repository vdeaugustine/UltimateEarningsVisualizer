//
//  FirstSavedItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/13/23.
//

import SwiftUI

extension View {
    @ViewBuilder func onChangeProper<Value>(of value: Value, _ action: @escaping () -> Void) -> some View where Value: Equatable {
        if #available(iOS 17, *) {
            self.onChange(of: value) {
                action()
            }
        } else {
            onChange(of: value) { _ in
                action()
            }
        }
    }

    @ViewBuilder func dismissKeyboardOnTap(focusStates: [FocusState<Bool>.Binding]) -> some View {
        overlay {
            if focusStates.contains(where: { $0.wrappedValue == true }) {
                Color.white.opacity(0.00000000000001)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        focusStates.forEach { state in
                            state.wrappedValue = false
                        }
                    }
            }
        }
    }
}

// MARK: - FirstSavedItemView

struct FirstSavedItemView: View {
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
                TextField("Bought money visualizer premium", text: $title)
                    .focused($titleFocused)
                    .defaultPopover(isPresented: $titlePopover, text: "How did you save money?", direction: .up)
            }

            Section("Info") {
                TextEditor(text: $info)
                    .placeholder("This will save me a bunch of money in the future!",
                                 text: $info)
                    .focused($infoFocused)
                    .offset(x: -4)
                    .defaultPopover(isPresented: $infoPopover, text: "Now put a little more information\nor a note to yourself about this occurrence.", direction: .up)
            }

            Section("Date") {
                DatePicker("Saved on", selection: $date)
                    .defaultPopover(isPresented: $datePopover, text: "Set a date to keep track of when you save", direction: .up)
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
                .defaultPopover(isPresented: $amountPopover, text: "Finally, enter the amount you saved!", direction: .up)
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
        .onChangeProper(of: datePopover, {
            if datePopover == false {
                amountPopover = true
            }
        })
        .onChangeProper(of: amountPopover, {
            if amountPopover == false {
                showEnterAmountSheet = true 
            }
        })
        .dismissKeyboardOnTap(focusStates: [$titleFocused, $infoFocused])
        .sheet(isPresented: $showEnterAmountSheet, content: {
            EnterDoubleView(dubToEdit: $amount, format: .dollar)
        })
    }
}

#Preview {
    FirstSavedItemView()
}
