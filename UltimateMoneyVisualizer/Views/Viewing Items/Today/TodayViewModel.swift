//
//  TodayViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/22/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

class TodayViewModel: ObservableObject {
    @Published var start: Date = .nineAM
    @Published var end: Date = .fivePM
    @Published var hasShownBanner = false
    @Published var nowTime: Date = .now
    @Published var selectedSegment: SelectedSegment = .money
    @Published var showBanner = false
    @Published var showDeleteWarning = false
    @Published var showHoursSheet = false
    @Published var todayShift: TodayShift? = User.main.todayShift

    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main
    @ObservedObject var wage = User.main.getWage()

    var willEarn: Double {
        user.getWage().perSecond * (todayShift?.totalShiftDuration ?? 0)
    }

    let initialPayoffs = User.main.getQueue().map {
        TempTodayPayoff(payoff: $0)
    }
    
    var haveEarned: Double {
        todayShift?.totalEarnedSoFar(nowTime) ?? 0
    }
    
    var taxesTempPayoffs: [TempTodayPayoff] {
        var expenses: [TempTodayPayoff] = []
        if wage.includeTaxes {
            if wage.stateTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.stateTaxMultiplier,
                          amountPaidOff: 0,
                          title: "State Tax",
                          id: .init())
                )
            }
            if wage.federalTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.federalTaxMultiplier,
                          amountPaidOff: 0,
                          title: "Federal Tax",
                          id: .init())
                )
            }
        }
        return expenses
    }

    var tempPayoffs: [TempTodayPayoff] {
        var expenses: [TempTodayPayoff] = []
        let wage = user.getWage()
        

        let expensesToPay = taxesTempPayoffs + initialPayoffs
        return payOffExpenses(with: haveEarned, expenses: expensesToPay).reversed()
    }

    var todayShiftPercentCompleted: Double {
        guard let todayShift else { return 0 }
        return todayShift.percentTimeCompleted(nowTime)
    }

    var todayShiftValueSoFar: String {
        guard let todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.totalEarnedSoFar(nowTime).formattedForMoney()

            case .time:
                return todayShift.elapsedTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var todayShiftRemainingValue: String {
        guard let todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.remainingToEarn(nowTime).formattedForMoney()
            case .time:
                return todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    let viewContext: NSManagedObjectContext
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(context: NSManagedObjectContext = PersistenceController.context) {
        self.viewContext = context
    }

    var isCurrentlyMidShift: Bool {
        guard let todayShift,
              let start = todayShift.startTime,
              let end = todayShift.endTime,
              nowTime >= start,
              nowTime <= end
        else {
            return false
        }
        return true
    }

    func addSecond() {
        nowTime = .now
        if todayShift != nil,
           !hasShownBanner {
            if isCurrentlyMidShift == false {
                showBanner = true
            }
        }
    }

    func deleteShift() {
        todayShift = nil
        if let userShift = user.todayShift {
            viewContext.delete(userShift)
        }
        user.todayShift = nil
    }

    func saveShift() {
        do {
            try todayShift?.finalizeAndSave(user: user, context: viewContext)
        } catch {
            print("Error saving")
        }
    }

    func totalValueForProgressSection() -> String {
        guard let todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.totalWillEarn.formattedForMoney()
            case .time:
                return todayShift.totalShiftDuration.formatForTime()
        }
    }

    enum SelectedSegment: String, CaseIterable, Identifiable, Hashable {
        case money, time
        var id: Self { self }
    }
}
