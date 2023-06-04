//
//  AllTimeBlocksForShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI

// MARK: - AllTimeBlocksForShiftView

struct AllTimeBlocksForShiftView: View {
    let shift: Shift
    @ObservedObject private var user: User = .main

    var body: some View {
        List {
            ForEach(shift.getTimeBlocks()) { block in

                VStack {
                    HStack {
                        if let title = block.title {
                            Text(title)
                        }

                        Spacer()

                        if let startTime = block.startTime {
                            Text(startTime.getFormattedDate(format: "H:mm a"))
                        }
                        Text("-")
                        if let endTime = block.endTime {
                            Text(endTime.getFormattedDate(format: "H:mm a"))
                        }
                    }
                    
                    HStack {
                        Text("Duration: \(block.duration.formatForTime())")
                        Spacer()
                        Text("Earned: \(block.amountEarned().formattedForMoney())")
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Time Blocks for \(shift.start.getFormattedDate(format: .abreviatedMonth))")
    }
}

// MARK: - AllTimeBlocksForShiftView_Previews

struct AllTimeBlocksForShiftView_Previews: PreviewProvider {
    static var previews: some View {
        AllTimeBlocksForShiftView(shift: User.main.getShifts().first!)
            .putInNavView(.inline)
    }
}
