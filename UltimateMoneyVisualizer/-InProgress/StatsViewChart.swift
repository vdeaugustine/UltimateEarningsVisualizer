//
//  StatsViewChart.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/7/23.
//

import Charts
import SwiftUI

// MARK: - StatsViewChart

struct StatsViewChart: View {
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()

    @State private var startDate: Date = .beginningOfDay().addDays(-20)
    @State private var endDate: Date = .endOfDay()

    var shifts: [Shift] {
        let shiftsBetween = user.getShiftsBetween(startDate: startDate, endDate: endDate)
        let sorted = shiftsBetween.sorted {
            DayOfWeek($0) < DayOfWeek($1)
        }
        
        return sorted
    }

    var body: some View {
        VStack {
            // 1. Add a chart element
            Chart(shifts) { item in
                // 2. Bar mark for each revenue item in the array
                BarMark(x: .value("Date", item.dayOfWeek ?? "NA"),
                        y: .value("Amount", item.totalEarned))
            }
        }
        .padding()
    }
}

// MARK: - StatsViewChart_Previews

struct StatsViewChart_Previews: PreviewProvider {
    static var previews: some View {
        StatsViewChart()
    }
}
