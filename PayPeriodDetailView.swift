//
//  SwiftUIView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/7/23.
//

import AlertToast
import SwiftPieChart
import SwiftUI

// MARK: - PayPeriodDetailView

struct PayPeriodDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let payPeriod: PayPeriod
    @State private var showDeleteConfirmation = false
    @State private var showDeleteFailAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            if let start = payPeriod.firstDate {
                Text("Start")
                    .spacedOut(text: start.getFormattedDate(format: .abreviatedMonth))
            }
            if let end = payPeriod.payDay {
                Text("Pay day")
                    .spacedOut(text: end.getFormattedDate(format: .abreviatedMonth))
            }

            Text("Total worked")
                .spacedOut(text: payPeriod.totalTimeWorked().formatForTime([.hour, .minute, .second]))
            Text("Total earned")
                .spacedOut(text: payPeriod.totalEarned().formattedForMoney())

            Text("Taxes paid")
                .spacedOut(text: payPeriod.taxesPaid().formattedForMoney())

            Section {
                GPTPieChart(pieChartData: [.init(color: .defaultColorOptions[0],
                                                 name: "State Taxes",
                                                 amount: payPeriod.stateTaxesPaid()),
                                           .init(color: .defaultColorOptions[1],
                                                 name: "Federal Taxes",
                                                 amount: payPeriod.federalTaxesPaid()),
                                           .init(color: .defaultColorOptions[7],
                                                 name: "Net Money",
                                                 amount: payPeriod.totalEarnedAfterTaxes())])
                .frame(height: 200)
            }
            .listRowBackground(Color.clear)

            Section("Shifts") {
                ForEach(payPeriod.getShifts()) { shift in
                    NavigationLink {
                        ShiftDetailView(shift: shift)
                    } label: {
                        ShiftRowView(shift: shift)
                    }
                }
            }
        }
        .bottomButton(label: "Delete",
                      gradient: Color.niceRed.getGradient()) {
            showDeleteConfirmation.toggle()
        }
        .navigationTitle(payPeriod.title)
        .putInTemplate()
        .toast(isPresenting: $showDeleteFailAlert, alert: { .errorWith(message: "Error deleting pay period") })
        .confirmationDialog("Delete pay period",
                            isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                do {
                    viewContext.delete(payPeriod)
                    try viewContext.save()
                    dismiss()
                } catch {
                    showDeleteFailAlert.toggle()
                    print("Failed to delete pay period \(error)")
                }
            }
        }
    }
}

// MARK: - PayPeriodDetailView_Previews

struct PayPeriodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PayPeriodDetailView(payPeriod: User.main.getPayPeriods().first!)
            .putInNavView(.inline)
    }
}
