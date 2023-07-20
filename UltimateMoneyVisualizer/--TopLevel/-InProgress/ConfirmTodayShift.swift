//
//  ConfirmTodayShift.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/14/23.
//

import SwiftUI
import Vin

// MARK: - ConfirmTodayShift

struct ConfirmTodayShift: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    @State private var paidOffItems: [TempTodayPayoff] = []

    var body: some View {
        List {
            Section {
                Text("Start")
                    .spacedOut(text: viewModel.start.getFormattedDate(format: .minimalTime))
                Text("End")
                    .spacedOut(text: viewModel.end.getFormattedDate(format: .minimalTime))
            } header: {
                Text("Details")
            }

            if !paidOffItems.isEmpty {
                Section {
                    GPTPieChart(pieChartData: viewModel.getConfirmShiftChartData(items: paidOffItems))
                        .frame(height: 200)
                    ForEach(paidOffItems) { payoff in
                        Text(payoff.title)
                            .spacedOut(text: payoff.progressAmount.formattedForMoney())
                    }
                    .onDelete(perform: { indexSet in
                        paidOffItems.remove(atOffsets: indexSet)
                    })
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Confirm Today Shift")
        .onAppear(perform: {
            paidOffItems = viewModel.tempPayoffs
        })
        
    }
}

// MARK: - ConfirmTodayShift_Previews

struct ConfirmTodayShift_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTodayShift()
            .putInNavView(.inline)
    }
}
