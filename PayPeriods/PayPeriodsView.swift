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
                NavigationLink {
                    PayPeriodSettingsView()
                } label: {
                    Text("Pay Period Settings")
                }
            }
            Section("Current") {
                payPeriodRow(viewModel.user.getCurrentPayPeriod())
            }
            Section("All") {
                ForEach(viewModel.user.getPayPeriods()) { period in
                    payPeriodRow(period)
                }
            }
        }
        .navigationTitle("Pay Periods")
        .putInTemplate()
    }

    func payPeriodRow(_ period: PayPeriod) -> some View {
        VStack(alignment: .leading) {
            Text(period.title)
            Text("Cadence: " + period.getCadence().rawValue)
            ForEach(period.getShifts()) { shift in
                Text(shift.title)
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
