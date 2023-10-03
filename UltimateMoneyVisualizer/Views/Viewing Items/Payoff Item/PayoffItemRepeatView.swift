//
//  PayoffItemRepeatView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/6/23.
//

import SwiftUI

// MARK: - PayoffItemRepeatView

struct PayoffItemRepeatView: View {
    
    @ObservedObject private var user = User.main
    
    let payoffItem: Expense

    @State private var futureDate: Date = .now.addDays(365)
    
    var dates: [Date] {
        payoffItem.getDaysBetweenTodayAndFutureDate(futureDate: futureDate)
    }
    
    var total: Double {
        Double(dates.count) * payoffItem.amount
    }
    
    
    
    var body: some View {
        List {
            Section {
                DatePicker("Between now and", selection: $futureDate, displayedComponents: .date)
                Text("Repeats")
                    .spacedOut(text: dates.count.str)
                Text("Total amount")
                    .spacedOut(text: total.money())
                Text("Total work time")
                    .spacedOut(text: user.convertMoneyToTime(money: total).breakDownTime())
            } header: {
                Text("Date").hidden()
            }
            

            ForEach(dates, id: \.self) { day in

                Text(day.getFormattedDate(format: .abbreviatedMonth))
            }
        }
        .putInTemplate(title: "Repeat Dates")
    }
}

// MARK: - PayoffItemRepeatView_Previews

struct PayoffItemRepeatView_Previews: PreviewProvider {
    static let expense: Expense = {
        let expense = try! Expense(title: "Test expense",
                              info: "For repeat view",
                              amount: 125,
                              dueDate: .now.addDays(7),
                              dateCreated: .now,
                              isRecurring: true,
                              recurringDate: .now.addDays(7),
                              tagStrings: ["Test for repeat", "Repeating"],
                              repeatFrequency: .weekly,
                              user: User.main,
                              context: PersistenceController.context)
        
        return expense

    }()

    static var previews: some View {
        DebugOperations.restoreToDefault()

        return PayoffItemRepeatView(payoffItem: expense).templateForPreview()
    }
}
