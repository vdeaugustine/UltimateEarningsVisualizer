//
//  StatsViewChart.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/7/23.
//

import Charts
import SwiftUI

// MARK: - StatsViewChart


// TODO: Expenses and Goals are not calculated correctly, also to do with due date vs allocated date 
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
    
    struct ChartData: Identifiable {
        var amount: Double
        var type: String
        var day: DayOfWeek
        var id: UUID
        
        init(amount: Double, type: String, day: DayOfWeek, id: UUID) {
            self.amount = amount
            self.type = type
            self.day = day
            self.id = id
        }
        
        init(_ shift: Shift) {
            self.amount = shift.totalEarned
            self.type = "shift".capitalized
            self.day = DayOfWeek(shift)
            self.id = UUID()
        }
        
        init(_ expense: Expense) {
            self.amount = expense.amount
            self.type = "expense".capitalized
            self.day = DayOfWeek(date: expense.dateCreated ?? .now)
            self.id = expense.getID()
        }
        
        init(_ goal: Goal) {
            self.amount = goal.amount
            self.type = "goal".capitalized
            self.day = DayOfWeek(date: goal.dateCreated ?? .now)
            self.id = goal.getID()
        }
        
        init(_ savedItem: Saved) {
            self.amount = savedItem.getAmount()
            self.type = "saved".capitalized
            self.day = DayOfWeek(date: savedItem.getDate())
            self.id = UUID()
        }
        
    }
    
    var chartData: [ChartData] {
        let shiftData = user.getShiftsBetween(startDate: startDate, endDate: endDate).map({ ChartData($0)})
        let savedData = user.getSavedBetween(startDate: startDate, endDate: endDate).map({ ChartData($0)})
        let expenseData = user.getExpensesBetween(startDate: startDate, endDate: endDate).map({ ChartData($0)})
        let goals = user.getGoalsBetween(startDate: startDate, endDate: endDate).map({ ChartData($0)})
        
        return shiftData + savedData + expenseData + goals
            
    }

    var body: some View {
        VStack {
            // 1. Add a chart element
            Chart(chartData) { item in
               
//                LineMark(x: .value("Date", item.dayOfWeek?.prefixStr(3) ?? "NA"), y: .value("Net Money", user.totalNetMoneyBetween(startDate, endDate)))
                BarMark(x: .value("Day", item.day.rawValue.capitalized.prefixStr(3)),
                        y: .value("Amount", item.amount))
                .foregroundStyle(by: .value("type", item.type))
                
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
