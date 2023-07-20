import CoreData
import Foundation
import SwiftUI
import Vin

// MARK: - TodayViewModel

class TodayViewModel: ObservableObject {
    // MARK: - Properties

    /// Main Payoff Queue that has been filtered out for only items that haven't been paid off
    let initialPayoffs: [TempTodayPayoff]
    static var main = TodayViewModel()
    let viewContext: NSManagedObjectContext
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let taxesColor = Color(hex: "630E08")
    let expensesColor = Color(hex: "00364A")
    let goalsColor = Color(hex: "4F4A2C")
    let unspentColor = Color(hex: "044A21")

    // MARK: - Published properties

    @Published var start: Date = User.main.regularSchedule?.getStartTime(for: .now) ?? Date.getThisTime(hour: 9, minute: 0)!
    @Published var end: Date = User.main.regularSchedule?.getEndTime(for: .now) ?? .fivePM
    @Published var hasShownBanner = false
    @Published var nowTime: Date = .now
    @Published var selectedSegment: SelectedSegment = .money
    @Published var showBanner = false
    @Published var showDeleteWarning = false
    @Published var showHoursSheet = false
    @Published var saveBannerWasDismissed = false

    // MARK: - Observed Objects

    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main
    @ObservedObject var wage = User.main.getWage()
    @ObservedObject var navManager = NavManager.shared

    // MARK: - Initializer

    init(context: NSManagedObjectContext = PersistenceController.context) {
        self.viewContext = context
        let allQueue = User.main.getQueue().filter { !$0.isPaidOff }
        //        let goalsPaidOff = allQueue.filter { $0.type == .expense }.map { TempTodayPayoff(payoff: $0) }
        //        let expensesPaidOff = allQueue.filter { $0.type == .goal }.map { TempTodayPayoff(payoff: $0) }

        self.initialPayoffs = allQueue.map { TempTodayPayoff(payoff: $0) }
    }

    // MARK: - Computed Properties
    
    var showExpensesProgress: Bool { spentOnExpenses >= 0.01 }
    var showGoalsProgress: Bool { spentOnGoals >= 0.01 }
    var showUnspent: Bool { 1 - spentTotal >= 0.01 }
    
    var timeStringForHeader: String {
        "\(start.getFormattedDate(format: .minimalTime)) - \(end.getFormattedDate(format: .minimalTime))"
    }

    var elapsedTime: Double {
        Date.now - start
    }

    var haveEarned: Double {
        user.todayShift?.totalEarnedSoFar(nowTime) ?? 0
    }

    var isCurrentlyMidShift: Bool {
        guard let todayShift = user.todayShift,
              let start = todayShift.startTime,
              let end = todayShift.endTime,
              nowTime >= start,
              nowTime <= end
        else {
            return false
        }
        return true
    }
    
    var remainingTime: Double {
        end - nowTime
    }

    var spentOnExpenses: Double {
        tempPayoffs.lazy.filter { $0.type == .expense }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var spentOnGoals: Double {
        tempPayoffs.lazy.filter { $0.type == .goal }.reduce(Double.zero) { $0 + $1.progressAmount }
    }
    
    var spentTotal: Double {
        spentOnGoals + spentOnExpenses + taxesPaidSoFar
    }
    
    var percentForExpenses: Double {
        spentOnExpenses / spentTotal
    }
    
    var percentForGoals: Double {
        spentOnGoals / spentTotal
    }
    
    var percentPaidSoFar: Double {
        spentTotal / willEarn
    }
    
    var percentForTaxesSoFar: Double {
        taxesPaidSoFar / spentTotal
    }
    

    var taxesPaidSoFar: Double {
        tempPayoffs.lazy.filter { $0.type == .tax }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var taxesTempPayoffs: [TempTodayPayoff] {
        var expenses: [TempTodayPayoff] = []
        if wage.includeTaxes {
            if wage.stateTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.stateTaxMultiplier,
                          amountPaidOff: 0,
                          title: "State Tax",
                          type: .tax,
                          id: .init())
                )
            }
            if wage.federalTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * wage.federalTaxMultiplier,
                          amountPaidOff: 0,
                          title: "Federal Tax",
                          type: .tax,
                          id: .init())
                )
            }
        }
        return expenses
    }

    var tempPayoffs: [TempTodayPayoff] {
        let expensesToPay = taxesTempPayoffs + initialPayoffs
        return payOffExpenses(with: haveEarned, expenses: expensesToPay).reversed()
    }

    var todayShiftPercentCompleted: Double {
        guard let todayShift = user.todayShift else { return 0 }
        return todayShift.percentTimeCompleted(nowTime)
    }

    var todayShiftRemainingValue: String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.remainingToEarn(nowTime).formattedForMoney()
            case .time:
                return todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var todayShiftValueSoFar: String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.totalEarnedSoFar(nowTime).formattedForMoney()
            case .time:
                return todayShift.elapsedTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var willEarn: Double {
        if wage.isSalary {
            return wage.perDay
        } else {
            return wage.perSecond * (user.todayShift?.totalShiftDuration ?? 0)
        }
    }

    // MARK: - Methods

    func addSecond() {
        nowTime = .now
        if user.todayShift != nil,
           !saveBannerWasDismissed {
            if nowTime > end {
                showBanner = true
            }
        }
    }

    func deleteShift() {
        user.todayShift = nil
        if let userShift = user.todayShift {
            viewContext.delete(userShift)
        }
        showBanner = false
        do {
            try user.getContext().save()
        } catch {
            fatalError(String(describing: error))
        }
    }

    func getConfirmShiftChartData(items: [TempTodayPayoff]) -> [GPTPieChart.PieSliceData] {
        var spentItems: [GPTPieChart.PieSliceData] = []

        let goals = items.lazy.filter { $0.type == .goal }.reduce(Double.zero) { $0 + $1.progressAmount }
        let expenses = items.lazy.filter { $0.type == .expense }.reduce(Double.zero) { $0 + $1.progressAmount }
        let taxes = items.lazy.filter { $0.type == .tax }.reduce(Double.zero) { $0 + $1.progressAmount }

        if taxes >= 0.01 {
            spentItems.append(.init(color: .niceRed, name: "Taxes", amount: taxes))
        }

        if goals > 0.01 {
            spentItems.append(
                .init(color: .defaultColorOptions[5],
                      name: "Goals",
                      amount: goals)
            )
        }

        if expenses > 0.01 {
            spentItems.append(
                .init(color: .defaultColorOptions[6],
                      name: "Expenses",
                      amount: expenses)
            )
        }

        let unspent = haveEarned - taxesPaidSoFar - goals - expenses
        if unspent > 0.01 {
            spentItems.append(.init(color: .defaultColorOptions[7], name: "Unspent", amount: unspent))
        }

        return spentItems
    }

    func saveShift() {
        navManager.todayViewNavPath.append(NavManager.AllViews.confirmToday)
    }

    func timeUntilShiftString() -> String {
        let timeComponent = start - nowTime
        if abs(timeComponent) < 86_400 {
            let hours = Int(timeComponent / 3_600)
            let minutes = Int((timeComponent.truncatingRemainder(dividingBy: 3_600)) / 60)
            let remainingSeconds = Int(timeComponent.truncatingRemainder(dividingBy: 60))

            let minutesString = String(format: "%02d", abs(minutes))
            let secondsString = String(format: "%02d", abs(remainingSeconds))

            var timeString = ""
            if hours > 0 {
                timeString += "\(hours):"
            }
            timeString += "\(minutesString):\(secondsString)"

            return timeString
        } else {
            return "0:00:00"
        }
    }

    func totalValueForProgressSection() -> String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.totalWillEarn.formattedForMoney()
            case .time:
                return todayShift.totalShiftDuration.formatForTime()
        }
    }
}

extension TodayViewModel {
    enum SelectedSegment: String, CaseIterable, Identifiable, Hashable {
        case money, time
        var id: Self { self }
    }
}
