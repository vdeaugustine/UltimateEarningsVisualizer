//
//  PayCycleVIewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/6/23.
//

import AlertToast
import Foundation
import SwiftUI

class PayCycleViewModel: ObservableObject {
    @ObservedObject var user = User.main
    @Environment(\.managedObjectContext) var viewContext
    @Published var selectedCycle: PayCycle = .biWeekly
    @Published var dayOfWeek: DayOfWeek = .friday
    @Published var toastConfig = AlertToast.errorWith(message: "")
    @Published var showToast = false
    @Published var nextPayDay: Date = .now

    func next3PayDays(from date: Date = Date()) -> [Date] {
        guard let firstDate = selectedCycle.nextPayDay(from: date) else { return [] }
        return (1...5).reduce(into: [firstDate]) { (dates, _) in
            if let nextDate = selectedCycle.nextPayDay(from: dates.last!) {
                dates.append(nextDate)
            }
        }
    }


//    var customIsSelected: Bool {
//        selectedCycle == .custom
//    }
}