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
    let taxesColor = Color.red // Color(hex: "630E08")
    let expensesColor = Color.cyan // Color(hex: "669D34")
    let goalsColor = Color.green // Color(hex: "9D3466")
    let unspentColor = Color.orange // Color(hex: "34669D")

    // #30FF3BFF
    //    #3B30FFFF
    //    kCGColorSpaceModelRGB 0.305882 0.478431 0.152941 1

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
    @Published var paidOffStackIsExpanded = false
    @Published var showDeleteConfirmation = false
    @Published var completedShiftTempPayoffs: [TempTodayPayoff] = []
    @Published var todayViewCurrentScrollOffset: CGFloat = 0

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

    // MARK: Handling segment controller

    var timeSegmentLabelWeight: Font.Weight {
        selectedSegment == .time ? .black : .regular
    }

    var moneySegmentLabelWeight: Font.Weight {
        selectedSegment == .money ? .black : .regular
    }

    var moneySegmentLabelSize: CGFloat {
        selectedSegment == .money ? 24 : 16
    }

    var timeSegmentLabelSize: CGFloat {
        selectedSegment == .time ? 24 : 16
    }

    var timeSegmentLabelColor: AnyShapeStyle {
        selectedSegment == .time ? AnyShapeStyle(settings.getDefaultGradient()) : AnyShapeStyle(Color.black)
    }

    var moneySegmentLabelColor: AnyShapeStyle {
        selectedSegment == .money ? AnyShapeStyle(settings.getDefaultGradient()) : AnyShapeStyle(Color.black)
    }

    // MARK: Progress calculations

    var haveEarned: Double {
        user.todayShift?.totalEarnedSoFar(nowTime) ?? 0
    }

    var isCurrentlyMidShift: Bool {
        guard let todayShift = user.todayShift,
              let startTime = todayShift.startTime,
              let endTime = todayShift.endTime,
              nowTime >= startTime,
              nowTime <= endTime
        else {
            return false
        }
        return true
    }

    var nonZeroPayoffItems: [TempTodayPayoff] {
        tempPayoffs.filter { $0.progressAmount > 0.01 }
    }

    var remainingTime: Double {
        guard let endTime = user.todayShift?.endTime else { return 0 }
        return endTime - nowTime
    }

    var showExpensesProgress: Bool { spentOnExpenses >= 0.01 }
    var showGoalsProgress: Bool { spentOnGoals >= 0.01 }
    var showUnspent: Bool { unspent >= 0.01 }

    // MARK: Spending

    var goalPayoffItems: [TempTodayPayoff] {
        tempPayoffs.lazy.filter { $0.type == .goal && $0.amountPaidOff > 0.01 }
    }

    var expensePayoffItems: [TempTodayPayoff] {
        tempPayoffs.lazy.filter { $0.type == .expense && $0.amountPaidOff > 0.01 }
    }

    var spentOnExpenses: Double {
        tempPayoffs.lazy.filter { $0.type == .expense }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var spentOnGoals: Double {
        tempPayoffs.lazy.filter { $0.type == .goal }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var spentOnPayoffItems: Double {
        spentOnExpenses + spentOnGoals
    }

    var spentTotal: Double {
        spentOnGoals + spentOnExpenses + taxesPaidSoFar
    }

    var unspent: Double {
        max(haveEarned - spentTotal, 0)
    }

    var percentForExpenses: Double {
        spentOnExpenses / spentTotal
    }

    var percentForGoals: Double {
        spentOnGoals / spentTotal
    }

    var percentPaidSoFar: Double {
        spentTotal / haveEarned
    }

    var percentForTaxesSoFar: Double {
        taxesPaidSoFar / spentTotal
    }

    var percentForUnpaid: Double {
        unspent / haveEarned
    }

    var taxesPaidSoFar: Double {
        tempPayoffs.lazy.filter { $0.type == .tax }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var haveEarnedAfterTaxes: Double {
        haveEarned - taxesPaidSoFar
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

    // MARK: Header

    var dateStringForHeader: String {
        guard let todayShift = user.todayShift,
              let startTime = todayShift.startTime else {
            return ""
        }
        return startTime.getFormattedDate(format: .abreviatedMonth)
    }

    var elapsedTime: Double {
        user.todayShift?.elapsedTime(nowTime) ?? 0
    }

    var timeStringForHeader: String {
        guard let todayShift = user.todayShift,
              let startTime = todayShift.startTime,
              let endTime = todayShift.endTime else {
            return ""
        }
        return "\(startTime.getFormattedDate(format: .minimalTime)) - \(endTime.getFormattedDate(format: .minimalTime))"
    }

    var todayShiftPercentCompleted: Double {
        guard let todayShift = user.todayShift else { return 0 }
        return todayShift.percentTimeCompleted(nowTime)
    }

    var todayShiftRemainingValue: String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.remainingToEarn(nowTime).money()
            case .time:
                return todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var willEarn: Double {
        if wage.isSalary {
            return wage.perDay
        } else {
            return wage.perSecond * (user.todayShift?.totalShiftDuration ?? 0)
        }
    }

    var willEarnAfterTaxes: Double {
        willEarn * (1 - wage.totalTaxMultiplier)
    }

    // MARK: - Methods

    func addSecond() {
        nowTime = .now
        if !saveBannerWasDismissed {
            showBanner = shiftIsOver
        }
    }

    var shiftIsOver: Bool {
        if let shift = user.todayShift,
           let endTime = shift.endTime {
            return nowTime >= endTime
        }
        return false
    }

    func tappedDeleteAction() {
        showDeleteConfirmation.toggle()
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

    func getPayoffItems(type: PayoffType) -> [TempTodayPayoff]? {
        let filtered = tempPayoffs.filter { $0.type == type && $0.amountPaidOff > 0.01 }
        if filtered.isEmpty { return nil }
        return filtered
    }
    
    func getPayoffListsHeight(forCount itemCount: Int) -> CGFloat? {
        let count = CGFloat(itemCount)
        let spaces = count - 1
        let heightOfRect: CGFloat = 110
        let heightOfSpace: CGFloat = 10
        return ((heightOfRect * CGFloat(count)) + CGFloat(count) * heightOfSpace  + 70)
    }

    func saveShift() {
        completedShiftTempPayoffs = tempPayoffs.filter { $0.progressAmount >= 0.01 }
        navManager.todayViewNavPath.append(NavManager.TodayViewDestinations.confirmShift)
    }

    func timeUntilShiftString() -> String {
        guard let startTime = user.todayShift?.startTime else { return "" }
        let timeComponent = startTime - nowTime
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
                return todayShift.totalWillEarn.money()
            case .time:
                return todayShift.totalShiftDuration.formatForTime()
        }
    }

    func tappedTimeSegment() {
        print("tapped")
        if selectedSegment == .time { return }
        withAnimation {
            selectedSegment = .time
        }
    }

    func tappedMoneySegment() {
        print("tapped")
        if selectedSegment == .money { return }
        withAnimation {
            selectedSegment = .money
        }
    }
}

extension TodayViewModel {
    enum SelectedSegment: String, CaseIterable, Identifiable, Hashable {
        case money, time
        var id: Self { self }

        mutating func toggle() {
            if self == .money {
                self = .time
                return
            }
            if self == .time { self = .money }
        }
    }
}

// MARK: - Extra Types

extension TodayViewModel {
    enum ProgressType: String {
        case expenses, goals, taxes, unspent, willPayTaxes
    }

    struct StartAndEnd: Hashable {
        let start: Date
        let end: Date
    }
}

// MARK: - Info Rects

extension TodayViewModel {
    var soFarTotalValue: String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.totalEarnedSoFar(nowTime).money()
            case .time:
                return todayShift.elapsedTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var soFarTotalLabel: String {
        switch selectedSegment {
            case .money:
                return "Earned"
            case .time:
                return "Worked"
        }
    }

    var remainingTotalValue: String {
        guard let todayShift = user.todayShift else { return "" }
        switch selectedSegment {
            case .money:
                return todayShift.remainingToEarn(nowTime).money()
            case .time:
                return todayShift.remainingTime(nowTime).formatForTime([.hour, .minute, .second])
        }
    }

    var taxesTotalValue: String {
        switch selectedSegment {
            case .money:
                return taxesPaidSoFar.money()
            case .time:
                return user.convertMoneyToTime(money: taxesPaidSoFar).formatForTime([.hour, .minute, .second])
        }
    }

    var expensesTotalValue: String {
        let value = spentOnExpenses
        switch selectedSegment {
            case .money:
                return value.money()
            case .time:
                return user.convertMoneyToTime(money: value).formatForTime([.hour, .minute, .second])
        }
    }

    var goalsTotalValue: String {
        let value = spentOnGoals
        switch selectedSegment {
            case .money:
                return value.money()
            case .time:
                return user.convertMoneyToTime(money: value).formatForTime([.hour, .minute, .second])
        }
    }

    var unspentTotalValue: String {
        let value = unspent
        switch selectedSegment {
            case .money:
                return value.money()
            case .time:
                return user.convertMoneyToTime(money: value).formatForTime([.hour, .minute, .second])
        }
    }
}

// MARK: - Itemized Part

extension TodayViewModel {
    var gaps: [Date] {
        guard let shift = user.todayShift else { return [] }
        var retArr: [Date] = []
        let shiftsBlocks = shift.getTimeBlocks()
        for blockIndex in shiftsBlocks.indices {
            guard let thisBlock = shiftsBlocks.safeGet(at: blockIndex),
                  let nextBlock = shiftsBlocks.safeGet(at: blockIndex + 1),
                  let thisBlockEnd = thisBlock.endTime,
                  let nextBlockStart = nextBlock.startTime
            else { continue }

            if !compareDates(thisBlockEnd, nextBlockStart, accuracy: .minute) {
                retArr.append(thisBlockEnd)
            }
        }

        return retArr
    }

    func compareDates(_ date1: Date, _ date2: Date, accuracy: AccuracyLevel) -> Bool {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let dateComponents = calendar.dateComponents(components, from: date1, to: date2)

        switch accuracy {
            case .year:
                return dateComponents.year == 0
            case .month:
                return dateComponents.year == 0 && dateComponents.month == 0
            case .day:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0
            case .hour:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0
            case .minute:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0 && dateComponents.minute == 0
            case .second:
                return dateComponents.year == 0 && dateComponents.month == 0 && dateComponents.day == 0 && dateComponents.hour == 0 && dateComponents.minute == 0 && dateComponents.second == 0
        }
    }

    enum AccuracyLevel {
        case year
        case month
        case day
        case hour
        case minute
        case second
    }

    func getBlockAfter(this block: TimeBlock) -> TimeBlock? {
        guard let shift = user.todayShift,
              let indexOfThisBlock = shift.getTimeBlocks().firstIndex(of: block)
        else { return nil }
        return shift.getTimeBlocks().safeGet(at: indexOfThisBlock + 1)
    }

    func startMatchesAnotherBlocksEnd(_ timeBlock: TimeBlock) -> Bool {
        guard let start = timeBlock.startTime,
              let shift = user.todayShift
        else { return false }
        for block in shift.getTimeBlocks() {
            if let end = block.endTime {
                if compareDates(start, end, accuracy: .minute) {
                    return true
                }
            }
        }
        return false
    }

    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
