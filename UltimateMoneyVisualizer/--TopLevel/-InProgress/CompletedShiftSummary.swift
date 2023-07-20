//
//  CompletedShiftSummary.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/12/23.
//

import SwiftUI

// MARK: - CompletedShiftSummary

struct CompletedShiftSummary: View {
    @EnvironmentObject private var viewModel: TodayViewModel

    @State private var tempPayoffs: [TempTodayPayoff] = []

    

    var body: some View {
        List {
            Text("Today's Shift Summary")
                .font(.title)

            ForEach(tempPayoffs) { payoff in
                HStack {
                    Text(payoff.title)
                    Spacer()
                    Text("$\(payoff.amountPaidOff, specifier: "%.2f")")
                }
            }
            .onDelete(perform: { indexSet in
                tempPayoffs.remove(atOffsets: indexSet)
            })

            Button("Create Allocations") {
                let shift: Shift
                do {
                    shift = try Shift(day: DayOfWeek(date: viewModel.start),
                                      start: viewModel.start,
                                      end: viewModel.end,
                                      user: viewModel.user,
                                      context: viewModel.viewContext) // get completed shift
                } catch {
                    fatalError("Problem making shift and allocations for today shift summary: \(error)")
                }
                for payoff in tempPayoffs {
                    do {
                        try Allocation(tempPayoff: payoff,
                                       shift: shift,
                                       user: viewModel.user,
                                       context: viewModel.viewContext)
                    } catch {
                        fatalError("Problem making shift and allocations for today shift summary: \(error)")
                    }
                }
                // TODO: - if a problem is being had for saving, check here
//                try user.managedObjectContext?.save()
                
                print("Successfully saved")
            }
        }
        .onAppear(perform: {
            self.tempPayoffs = viewModel.tempPayoffs.filter { $0.progressAmount >= 0.01 }
        })
    }
}

// MARK: - CompletedShiftSummary_Previews

struct CompletedShiftSummary_Previews: PreviewProvider {
    static var previews: some View {
        CompletedShiftSummary()
            .environmentObject(TodayViewModel.main)
    }
}
