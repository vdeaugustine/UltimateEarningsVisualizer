//
//  PayoffItemRepeatView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/6/23.
//

import SwiftUI

// MARK: - PayoffItemRepeatView

struct PayoffItemRepeatView: View {
    let payoffItem: Expense

    @State private var futureDate: Date = .now.addDays(365)

    var body: some View {
        List {
            DatePicker("Between now and", selection: $futureDate, displayedComponents: .date)

            ForEach(payoffItem.getDaysBetweenTodayAndFutureDate(futureDate: futureDate), id: \.self) { day in

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

        return PayoffItemRepeatView(payoffItem: expense)
    }
}
