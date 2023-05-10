//
//  EditSavedItemView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/9/23.
//

import AlertToast
import SwiftUI

// MARK: - EditSavedItemView

struct EditSavedItemView: View {
    @Binding var savedItem: Saved
    @State private var title: String
    @State private var info: String
    @State private var amount: Double
    @State private var date: Date
    @State private var amountStr: String

    init(saved: Binding<Saved>) {
        _title = State(initialValue: saved.wrappedValue.getTitle())
        _info = State(initialValue: saved.wrappedValue.info ?? "")
        _amount = State(initialValue: saved.wrappedValue.amount)
        _date = State(initialValue: saved.wrappedValue.getDate())
        _amountStr = State(initialValue: saved.wrappedValue.amount.formattedForMoney().replacingOccurrences(of: "$", with: ""))
        _savedItem = saved
    }

    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showAlert = false
    @State private var alertConfig = AlertToast(displayMode: .alert, type: .complete(User.main.getSettings().themeColor))

    @FocusState private var focusedField: FocusOptions?

    enum FocusOptions: Hashable {
        case title, description, amount
    }

    var last4Shifts: [Shift] { user.getShifts().prefixArray(4) }

    var body: some View {
        List {
            Section("Title") {
                TextField("Title", text: $title)
                    .focused($focusedField, equals: .title)
            }

            Section("Description") {
                TextEditor(text: $info)
                    .focused($focusedField, equals: .description)
                    .frame(height: 200)
            }

            Section("Total Amount") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: settings.themeColor)
                    TextField("$", text: $amountStr)
                        .focused($focusedField, equals: .amount)
                }
            }

            Section("Instances") {
            }
        }
        .listStyle(.insetGrouped)

        .padding(.bottom)
        .background(Color.targetGray)
        .putInTemplate()
        .navigationTitle("Edit Item")
        .bottomButton(label: "Save") {
            guard let dub = Double(amountStr) else {
                alertConfig = .init(displayMode: .alert, type: .error(settings.themeColor), title: "Please enter a valid number for the amount.")
                amountStr = ""
                showAlert = true
                return
            }
            savedItem.title = title
            savedItem.amount = dub
            savedItem.info = info.isEmpty ? nil : info
            savedItem.date = date

            do {
                try viewContext.save()
                alertConfig = .init(displayMode: .alert, type: .complete(settings.themeColor), title: "Saved successfully")
                showAlert = true
            } catch {
                alertConfig = .init(displayMode: .alert, type: .error(settings.themeColor), title: "Error saving. Please close the app and try again.")
                showAlert = true
            }
        }
        .toast(isPresenting: $showAlert, alert: { alertConfig })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Clear") {
                    if focusedField == .amount {
                        amountStr = ""
                    }
                    if focusedField == .description {
                        info = ""
                    }
                    if focusedField == .title {
                        title = ""
                    }
                }

                Spacer()

                Button(focusedField == .amount ? "Done" : "Next") {
                    switch _focusedField.wrappedValue {
                        case .amount:
                            focusedField = nil

                        case .description:
                            focusedField = .amount
                        case .title:
                            focusedField = .description
                        default:
                            break
                    }
                }
            }
        }
    }
}

// MARK: - EditSavedItemView_Previews

struct EditSavedItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditSavedItemView(saved: .constant(User.main.getSaved().first!))
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
