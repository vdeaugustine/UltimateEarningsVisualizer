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
            Text("Cadence: " + period.getCadence().rawValue)
            Text("Date Set " + viewModel.format(period.dateSet))
            Text("Start Date: " + viewModel.format(period.firstDate))
            Text("Pay date: " + viewModel.format(period.payDay))
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
