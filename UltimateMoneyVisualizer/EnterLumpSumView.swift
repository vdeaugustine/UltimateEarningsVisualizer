//
//  EnterLumpSumView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/28/23.
//

import SwiftUI

// MARK: - EnterLumpSumView

struct EnterLumpSumView: View {
    @State private var amount: Double = 0
    @State private var showSheet: Bool = false
    @ObservedObject private var user: User = .main
    @Environment(\.dismiss) private var dismiss
    @State private var showErrorAlert = false
    @State private var errorString: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isFromWorking = false
    @State private var fromSavings: Double = 0
    @State private var fromWages: Double = 0

    @State private var savingsLimit: Double = 0
    @State private var wagesLimit: Double = 0

    var body: some View {
        Form {
            Section("Amount") {
                Button {
                    showSheet.toggle()
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign")
                        Text(amount.simpleStr(2, false, useCommas: true))
                            .font(.headline)
                        Spacer()
                        Text("Edit")
                    }
                }
                .foregroundStyle(.black)
            }

            Section("Mark as earned wages") {
                Toggle("Is from working", isOn: $isFromWorking)
            }

            Section("Source") {
                DisclosureGroup {
                    Slider(value: $fromSavings, in: 0 ... amount)

                } label: {
                    HStack {
                        Text("From savings")
                        Spacer()
                        Text(fromSavings.money())
                    }
                }
                .listRowSeparator(.hidden)

                DisclosureGroup {
                    Slider(value: $fromWages, in: 0 ... amount)

                } label: {
                    HStack {
                        Text("From wages")
                        Spacer()
                        Text(fromWages.money())
                    }
                }
                .listRowSeparator(.hidden)
            }

            Button("Save") {
                do {
//                    if let bank = user.bank {
//                        bank.amount = amount
//                        bank.isFromWorking = isFromWorking
//                    } else {
                        let bank = Bank(context: viewContext)
                        bank.user = user
                        bank.amount = amount
                        bank.isFromWorking = isFromWorking
//                    }

                    try viewContext.save()
                    dismiss()
                } catch {
                    errorString = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            EnterDoubleView(dubToEdit: $amount, format: .dollar)
        })
        .onAppear {
//            guard let existing = user.bank else { return }
//            amount = existing.amount
        }
        .alert("Error saving amount", isPresented: $showErrorAlert) {} message: {
            Text(errorString)
        }
        .putInTemplate(title: "Enter amount")
        .onChange(of: fromSavings, perform: { value in
            let availableForWages = amount - value
            if availableForWages < 0 {
                wagesLimit -= abs(availableForWages)
                fromWages = abs(availableForWages)
            }
        })
        .onChange(of: fromWages, perform: { value in
            let availableForSavings = amount - value
            if availableForSavings < 0 {
                savingsLimit -= abs(availableForSavings)
                fromSavings = availableForSavings
            }
        })
        .onChange(of: amount, perform: { _ in
            wagesLimit = amount - fromSavings
            savingsLimit = amount - fromWages
        })
    }
}

#Preview {
    EnterLumpSumView()
}
