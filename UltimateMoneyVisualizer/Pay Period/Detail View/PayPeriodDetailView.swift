//
//  SwiftUIView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/7/23.
//

import AlertToast
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
            if let start = payPeriod.firstDate,
               let end = payPeriod.payDay {
                Section {
                    HorizontalDataDisplay(data: [.init(label: "Start",
                                                       value: start.getFormattedDate(format: .slashDate),
                                                       view: nil),
                                                 .init(label: "Pay Day",
                                                       value: end.getFormattedDate(format: .slashDate),
                                                       view: nil),
                                                 .init(label: "Shifts",
                                                       value: payPeriod.getShifts().count.str,
                                                       view: nil)])
                        .frame(maxWidth: .infinity, alignment: .center)

//                        .padding(.horizontal, -50)
//                        .padding(.vertical, -20)
//                        .centerInParentView()
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                } header: {
                    Text("Details").hidden()
                }
            }

            HStack {
                SystemImageWithFilledBackground(systemName: "hourglass")
                Text("Total worked")
                Spacer()
                Text(payPeriod.totalTimeWorked().formatForTime([.hour, .minute, .second]))
                    .fontWeight(.medium)
            }

            HStack {
                SystemImageWithFilledBackground(systemName: "dollarsign")
                Text("Total Earned")
                Spacer()
                Text(payPeriod.totalEarned().money())
                    .fontWeight(.medium)
            }

            HStack {
                SystemImageWithFilledBackground(systemName: "dollarsign.arrow.circlepath")
                Text("Taxes paid")
                Spacer()
                Text(payPeriod.taxesPaid().money())
                    .fontWeight(.medium)
            }

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
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listRowBackground(Color.clear)

            Section("Shifts") {
                ForEach(payPeriod.getShifts()) { shift in
                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .shift(shift))
                    } label: {
                        ShiftRowView(shift: shift)
                    }
                }
            }

//            Button("Delete", role: .destructive) {
//                showDeleteConfirmation.toggle()
//            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Pay Period")
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
        NavigationView {
            Group {
                PayPeriodDetailView(payPeriod: User.main.getPayPeriods().first!)
                    .previewDevice("iPhone SE (3rd generation)")
                    .putInNavView(.inline)
                PayPeriodDetailView(payPeriod: User.main.getPayPeriods().first!)
                    .previewDevice("iPhone 14 Pro Max")
                    .putInNavView(.inline)
            }
        }
    }
}
