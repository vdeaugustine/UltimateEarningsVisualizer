//
//  AllocateShiftToExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import SwiftUI
import Combine

struct MoneyTextField: View {
    @Binding var value: Double
    @State private var amount: String = ""

    var body: some View {
        TextField("Enter amount", text: $amount, onCommit: {
            if let newValue = Double(amount) {
                value = newValue
            }
        })
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.trailing)
        .onReceive(Just(amount)) { newValue in
            let filteredValue = newValue.filter { "0123456789.".contains($0) }
            if filteredValue != newValue {
                amount = filteredValue
            }
        }
        .overlay(
            Text("\(amount.isEmpty ? "" : "$")")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 6)
        )
        .onAppear {
            amount = String(format: "%.2f", value)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    hideKeyboard()
                }
            }
        }
    }
}

struct MoneyTextField_Previews: PreviewProvider {
    @State static var value: Double = 0

    static var previews: some View {
        MoneyTextField(value: $value)
            .padding()
    }
}



struct AllocateShiftToExpense: View {
    let shift: Shift
    let expense: Expense
    
    @State private var amountToAllocate: String = ""
    @State private var amount: Double = 0
    
    
    var body: some View {
        Form {
            Section("Expense") {
                Text("Remaining to pay off")
                    .spacedOut(text: expense.amountRemainingToPayOff.formattedForMoney())
            }
            
            Section("Shift") {
                Text("Available to use")
                    .spacedOut(text: shift.totalAvailable.formattedForMoney())
                
                TextField("Amount", text: $amountToAllocate)
                MoneyTextField(value: $amount)
            }
            
            
        }
    }
}

struct AllocateShiftToExpense_Previews: PreviewProvider {
    static var previews: some View {
        AllocateShiftToExpense(shift: User.main.getShifts().first!,
                               expense: User.main.getExpenses().first!)
    }
}
