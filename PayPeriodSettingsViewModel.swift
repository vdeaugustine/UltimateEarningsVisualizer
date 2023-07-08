//
//  PayCycleVIewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/6/23.
//

import AlertToast
import Foundation
import SwiftUI

class PayPeriodSettingsViewModel: ObservableObject {
    @ObservedObject var user = User.main
    @Published var selectedCycle: PayCycle = User.main.payPeriodSettings?.getCycleCadence() ?? .biWeekly
    @Published var dayOfWeek: DayOfWeek = .friday
    @Published var toastConfig = AlertToast.errorWith(message: "")
    @Published var showToast = false
    @Published var firstDay: Date = .now
    @Published var nextPayDay: Date = .now.addDays(PayCycle.biWeekly.days)
    @Published var automaticallyGeneratePayPeriods: Bool = User.main.payPeriodSettings?.autoGeneratePeriods ?? true

    @Published var showAlertToCreatePreviousPeriods = false

    var autoGenerateFooterString: String {
        if automaticallyGeneratePayPeriods {
            return "A new pay period will automatically be created whenever you finish your most recent one."
        } else {
            return "You will create your own pay periods manually."
        }
    }

    var createPreviousText: String {
        "Would you like to automatically generate pay periods for previous shifts?"
    }

    func next3PayDays(from date: Date = Date()) -> [Date] {
        guard let firstDate = selectedCycle.nextPayDay(from: date) else { return [] }
        return (1 ... 5).reduce(into: [firstDate]) { dates, _ in
            if let nextDate = selectedCycle.nextPayDay(from: dates.last!) {
                dates.append(nextDate)
            }
        }
    }

    func confirmAction() {
        do {
            let settings = try PayPeriodSettings(cycleCadence: selectedCycle,
                                                 autoGenerate: automaticallyGeneratePayPeriods,
                                                 user: user,
                                                 context: user.getContext())
            try PayPeriod(firstDate: firstDay,
                          settings: settings,
                          user: user,
                          context: user.getContext())
            toastConfig = .successWith(message: "Successfully saved pay period.")
            showToast.toggle()
            showAlertToCreatePreviousPeriods.toggle()
        } catch {
            toastConfig = .errorWith(message: "Error saving pay cycle.")
            showToast.toggle()
        }
    }

    func confirmedCreateOnAlert() {
    }

//    var customIsSelected: Bool {
//        selectedCycle == .custom
//    }
}
