//
//  SwiftUIView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/6/23.
//

import SwiftUI

// MARK: - PayPeriodsView

struct PayPeriodsView: View {
    @StateObject private var viewModel: PayPeriodsViewModel = .init()

    var body: some View {
        List {
            Section {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .payPeriodSettings)
                } label: {
                    Text("Pay Period Settings")
                }
            } header: {
                Text("Settings").hidden()
            }
//            Section("Current") {
//                
//                PayPeriodRow(payPeriod: viewModel.user.getCurrentPayPeriod(), isCurrent: true)
//                
//            }
            Section("All") {
                ForEach(viewModel.user.getPayPeriods()) { period in
                    PayPeriodRow(payPeriod: period, isCurrent: period == viewModel.user.getCurrentPayPeriod())
                }
            }
        }
        .navigationTitle("Pay Periods")
        .putInTemplate()
    }

    func payPeriodRow(_ period: PayPeriod) -> some View {
        Button {
            NavManager.shared.appendCorrectPath(newValue: .payPeriodDetail(period))
        } label: {
            VStack(alignment: .leading) {
                Text(period.title)
                    .spacedOut {
                        Text("Cadence: " + period.getCadence().rawValue)
                    }

                Text(period.getShifts().count.str + " shifts")
            }
        }
    }
}

// MARK: - PayPeriodsView_Previews

struct PayPeriodsView_Previews: PreviewProvider {
    static var previews: some View {
        PayPeriodsView()
            .putInNavView(.inline)
            .onAppear(perform: {
            })
    }
}
