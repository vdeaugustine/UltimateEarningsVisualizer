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

struct SavedItemTutorial: View {
    @State private var title = ""
    @State private var info = ""
    @State private var date: Date = .now
    @State private var amount: Double = 0

    @State private var titlePopover = false
    @State private var infoPopover = false
    @State private var datePopover = false
    @State private var amountPopover = false
    
    @FocusState var titleFocused: Bool
    @FocusState var infoFocused: Bool
    
    @State private var showSaveButton = false
    @State private var savePopover = false
    
    @ObservedObject private var settings = User.main.getSettings()

    @State private var showEnterAmountSheet = false

    static let defaultTitle = "Made coffee at home"
    static let defaultInfo = "Instead of going to cafe before work"
    static let defaultAmount = Double(5)
    
    
    
    var body: some View {
        Form {
            Section("Title") {
                TextField(SavedItemTutorial.defaultTitle, text: $title)
                    .focused($titleFocused)
                    .defaultPopover(isPresented: $titlePopover, text: "Start by entering the title", direction: .up)
                    .allowsHitTesting(false)
            }
            

            Section("Info") {
                TextEditor(text: $info)
                    .placeholder(SavedItemTutorial.defaultInfo,
                                 text: $info)
                    .focused($infoFocused)
                    .offset(x: -4)
                    .defaultPopover(isPresented: $infoPopover, text: "Now put a little more information\nor a note to yourself about this occurrence.", direction: .up)
                    .allowsHitTesting(false)
            }

            Section("Date") {
                DatePicker("Saved on", selection: $date)
                    .defaultPopover(isPresented: $datePopover, text: "Set a date to keep track of when you save", direction: .up)
                    .allowsHitTesting(false)
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
        .putInTemplate(title: "Create Saved Item")
        .onAppear(perform: {
            // This is necessary to give the view loading in time to get ready to show the popover
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                titlePopover = true
            }
        })
        .onChangeProper(of: titlePopover) {
            if titlePopover == false {
                // titleFocused = true
                simulateTypeText(SavedItemTutorial.defaultTitle, into: $title) {
                    infoPopover = true
                }
            }
        }
        .onChangeProper(of: titleFocused) {
            if titleFocused == false {
                infoPopover = true
            }
        }
        .onChangeProper(of: infoPopover) {
            if infoPopover == false {
//                infoFocused = true
                simulateTypeText(SavedItemTutorial.defaultInfo, into: $info, delay: 0.05) {
                    datePopover = true
                }
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
//                showEnterAmountSheet = true
                amount = SavedItemTutorial.defaultAmount
                showSaveButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    savePopover = true
                }
            }
        })
        .toolbar {
            if showSaveButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                    }
                    .foregroundStyle(.white)
                    .defaultPopover(isPresented: $savePopover, text: "Now you can hit save", direction: .right)
                }
                
            }
        }
        .dismissKeyboardOnTap(focusStates: [$titleFocused, $infoFocused])
        .sheet(isPresented: $showEnterAmountSheet, content: {
            EnterDoubleView(dubToEdit: $amount, format: .dollar)
        })
        
    }
    
    func simulateTypeText(_ text: String, into state: Binding<String>, delay: Double = 0.05, _ completion: (() -> Void)? = nil) {
        for i in text.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(text.distance(from: text.startIndex, to: i))) {
                state.wrappedValue = String(text[...i])
                if i == text.index(before: text.endIndex) {
                    completion?()
                }
            }
        }
    }
    
}

#Preview {
    NavigationView {
        SavedItemTutorial()
    }
        
}
