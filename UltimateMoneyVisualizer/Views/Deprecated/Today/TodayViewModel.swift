import Combine
import CoreData
import Foundation
import SwiftUI
import Vin

// MARK: - TodayViewModel

class TodayViewModel: ObservableObject {
    // MARK: - Properties

    static var main = TodayViewModel()
    let viewContext: NSManagedObjectContext
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let taxesColor = Components.taxesColor // Color(hex: "630E08")
    let expensesColor = Components.expensesColor // Color(hex: "669D34")
    let goalsColor = Components.goalsColor // Color(hex: "9D3466")
    let unspentColor = Components.unspentColor // Color(hex: "34669D")

    // #30FF3BFF
    //    #3B30FFFF
    //    kCGColorSpaceModelRGB 0.305882 0.478431 0.152941 1

    // MARK: - Published properties

    // swiftformat:sort:begin
    @Published var completedShiftTempPayoffs: [TempTodayPayoff] = []
    @Published var end: Date = User.main.regularSchedule?.getEndTime(for: .now) ?? .fivePM
    @Published var hasShownBanner = false
    /// Main Payoff Queue that has been filtered out for only items that haven't been paid off
    ///
    /// If the user modifies the queue at any point during a TodayShift, this value will need to be set again because the tempPayoffs calculated property grabs from here each time
    /// So, since this var initially grabs from the MainQueue, we need to know if the temp queue has been modified since that time
    @Published var initialPayoffs: [TempTodayPayoff]
    @Published var nowTime: Date = .now
    @Published var paidOffStackIsExpanded = false
    @Published var saveBannerWasDismissed = false
    @Published var selectedSegment: SelectedSegment = .money
    @Published var showBanner = false
    @Published var showDeleteConfirmation = false
    @Published var showDeleteWarning = false
    @Published var showHoursSheet = false

    @Published var start: Date = User.main.regularSchedule?.getStartTime(for: .now) ?? Date.getThisTime(hour: 9, minute: 0)!
    @Published var timeBlocksExpanded: Bool = true
    @Published var todayViewCurrentScrollOffset: CGFloat = 0
    // swiftformat:sort:end

    // MARK: - Observed Objects

    // swiftformat:sort:begin
    @ObservedObject var navManager = NavManager.shared
    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main
    @ObservedObject var wage = User.main.getWage()

    // swiftformat:sort:end

    // MARK: - Initializer

    init(context: NSManagedObjectContext = PersistenceController.context) {
        self.viewContext = context
        self.initialPayoffs = []
        updateInitialPayoffs()
    }

    func updateInitialPayoffs() {
        let allQueue = user.getQueue().filter { !$0.isPaidOff }
        initialPayoffs = allQueue.enumerated().map { index, element in
            TempTodayPayoff(payoff: element, queueSlotNumber: index)
        }
    }

    // MARK: - Computed Properties

    // MARK: Handling segment controller

    // swiftformat:sort:begin
    var moneySegmentLabelColor: AnyShapeStyle {
        selectedSegment == .money ? AnyShapeStyle(settings.getDefaultGradient()) : AnyShapeStyle(Color.black)
    }

    var moneySegmentLabelSize: CGFloat {
        selectedSegment == .money ? 24 : 16
    }

    var moneySegmentLabelWeight: Font.Weight {
        selectedSegment == .money ? .black : .regular
    }

    var timeSegmentLabelColor: AnyShapeStyle {
        selectedSegment == .time ? AnyShapeStyle(settings.getDefaultGradient()) : AnyShapeStyle(Color.primary)
    }

    var timeSegmentLabelSize: CGFloat {
        selectedSegment == .time ? 24 : 16
    }

    var timeSegmentLabelWeight: Font.Weight {
        selectedSegment == .time ? .black : .regular
    }

    // swiftformat:sort:end

    // MARK: Progress calculations

    // swiftformat:sort:begin
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
    // swiftformat:sort:end

    // MARK: Spending

    // swiftformat:sort:begin
    var expensePayoffItems: [TempTodayPayoff] {
        tempPayoffs.lazy.filter { $0.type == .expense && $0.amountPaidOff > 0.01 }
    }

    var goalPayoffItems: [TempTodayPayoff] {
        tempPayoffs.lazy.filter { $0.type == .goal && $0.amountPaidOff > 0.01 }
    }

    var haveEarnedAfterTaxes: Double {
        haveEarned - taxesPaidSoFar
    }

    var percentForExpenses: Double {
        spentOnExpenses / spentTotal
    }

    var percentForGoals: Double {
        spentOnGoals / spentTotal
    }

    var percentForTaxesSoFar: Double {
        taxesPaidSoFar / spentTotal
    }

    var percentForUnpaid: Double {
        unspent / haveEarned
    }

    var percentPaidSoFar: Double {
        spentTotal / haveEarned
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

    var taxesPaidSoFar: Double {
        tempPayoffs.lazy.filter { $0.type == .tax }.reduce(Double.zero) { $0 + $1.progressAmount }
    }

    var taxesRemainingToPay: Double {
        willPayInTaxes - taxesPaidSoFar
    }

    var taxesTempPayoffs: [TempTodayPayoff] {
        var expenses: [TempTodayPayoff] = []
        if user.getWage().includeTaxes {
            if user.getWage().stateTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * user.getWage().stateTaxMultiplier,
                          amountPaidOff: 0,
                          title: "State Tax",
                          type: .tax,
                          id: .init(),
                          queueSlotNumber: 0)
                )
            }
            if user.getWage().federalTaxPercentage > 0 {
                expenses.append(
                    .init(amount: willEarn * user.getWage().federalTaxMultiplier,
                          amountPaidOff: 0,
                          title: "Federal Tax",
                          type: .tax,
                          id: .init(),
                          queueSlotNumber: 0)
                )
            }
        }
        return expenses
    }

    var tempPayoffs: [TempTodayPayoff] {
        
        let nonTaxes = initialPayoffs.filter({
            $0.queueSlotNumber != nil &&
            $0.type != .tax
        })
        let payoffsToPay = taxesTempPayoffs + initialPayoffs
        
        return payOfPayoffItems(with: haveEarned, payoffItems: payoffsToPay)
            .sorted{
                if $0.type == .tax { return true }
                if $1.type == .tax { return false }

                return ($0.queueSlotNumber ?? 999) < ($1.queueSlotNumber ?? 999)
            }
    }

    var unspent: Double {
        max(haveEarned - spentTotal, 0)
    }

    var willPayInTaxes: Double {
        willEarn * wage.totalTaxMultiplier
    }

    // swiftformat:sort:end

    // MARK: Header

    // swiftformat:sort:begin
    var dateStringForHeader: String {
        guard let todayShift = user.todayShift,
              let startTime = todayShift.startTime else {
            return ""
        }
        return startTime.getFormattedDate(format: .abbreviatedMonth)
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
        if user.getWage().isSalary {
            return user.getWage().perDay
        } else {
            return user.getWage().perSecond * (user.todayShift?.totalShiftDuration ?? 0)
        }
    }

    var willEarnAfterTaxes: Double {
        willEarn * (1 - user.getWage().totalTaxMultiplier)
    }

    // swiftformat:sort:end

    // MARK: - Methods

    // swiftformat:sort:begin
    func addSecond() {
        nowTime = .now
        if !saveBannerWasDismissed {
            showBanner = shiftIsOver
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
        return ((heightOfRect * CGFloat(count)) + CGFloat(count) * heightOfSpace + 70)
    }

    func saveShift() {
        completedShiftTempPayoffs = tempPayoffs.filter { $0.progressAmount > 0.01 }

        navManager.appendCorrectPath(newValue: .confirmToday)
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

    func tappedMoneySegment() {
        print("tapped")
        if selectedSegment == .money { return }
        selectedSegment = .money
    }

    func tappedTimeSegment() {
        print("tapped")
        if selectedSegment == .time { return }
        selectedSegment = .time
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

    // swiftformat:sort:end
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
    struct InfoRect {
        var imageName: String? = nil
        let valueString: String
        let bottomLabel: String
        let circleColor: Color
    }

    var infoRects: [InfoRect] { [InfoRect(imageName: "stopwatch",
                                          valueString: soFarTotalValue,
                                          bottomLabel: soFarTotalLabel,
                                          circleColor: .blue),
                                 InfoRect(imageName: "dollarsign.circle",
                                          valueString: afterTaxTotalValue,
                                          bottomLabel: "After Tax",
                                          circleColor: .green),
                                 InfoRect(valueString: taxesTotalValue,
                                          bottomLabel: "Taxes",
                                          circleColor: Color.red),
                                 InfoRect(valueString: expensesTotalValue,
                                          bottomLabel: "Expenses",
                                          circleColor: expensesColor),
                                 InfoRect(valueString: goalsTotalValue,
                                          bottomLabel: "Goals",
                                          circleColor: goalsColor),
                                 InfoRect(valueString: unspentTotalValue,
                                          bottomLabel: "Unspent",
                                          circleColor: unspentColor)] }

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

    var afterTaxTotalValue: String {
        switch selectedSegment {
            case .money:
                return haveEarnedAfterTaxes.money()
            case .time:
                return user.convertMoneyToTime(money: haveEarnedAfterTaxes).breakDownTime()
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

    var timeBlockCount: Int {
        user.todayShift?.getTimeBlocks().count ?? 0
    }

    var timeBlocksHeaderButtonName: String {
        timeBlocksExpanded ? "slider.horizontal.below.square.filled.and.square" : "calendar.day.timeline.left"
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

// MARK: - Confirm Today Shift

extension TodayViewModel {
    func tappedSaveOnConfirmShiftView(goals: [TempTodayPayoff], expenses: [TempTodayPayoff]) throws -> (shift: Shift, allocations: [Allocation]) {
        guard let todayShift = user.todayShift else {
            throw (NSError(domain: "No today shift", code: 1))
        }
        let shift = try Shift(fromTodayShift: todayShift, context: viewContext)

        var newAllocations = [Allocation]()

        for goal in goals {
            newAllocations.append(try Allocation(tempPayoff: goal, shift: shift, user: user, context: viewContext))
        }

        for expense in expenses {
            newAllocations.append(try Allocation(tempPayoff: expense, shift: shift, user: user, context: viewContext))
        }

        return (shift, newAllocations)
    }
}
