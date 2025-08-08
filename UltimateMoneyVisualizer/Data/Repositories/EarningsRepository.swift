// Disabled – defined in `UltimateMoneyVisualizer/--TopLevel/UltimateMoneyVisualizerApp.swift`
#if false
import Foundation

protocol EarningsRepository {
    func getShiftsBetween(startDate: Date, endDate: Date) -> [Shift]
    func getExpensesBetween(startDate: Date, endDate: Date) -> [Expense]
    func getSavedBetween(startDate: Date, endDate: Date) -> [Saved]
    func getGoalsBetween(startDate: Date, endDate: Date) -> [Goal]
}

struct DefaultEarningsRepository: EarningsRepository {
    private let userProvider: UserProviding
    init(userProvider: UserProviding) { self.userProvider = userProvider }

    func getShiftsBetween(startDate: Date, endDate: Date) -> [Shift] {
        userProvider.current.getShiftsBetween(startDate: startDate, endDate: endDate)
    }
    func getExpensesBetween(startDate: Date, endDate: Date) -> [Expense] {
        userProvider.current.getExpensesBetween(startDate: startDate, endDate: endDate)
    }
    func getSavedBetween(startDate: Date, endDate: Date) -> [Saved] {
        userProvider.current.getSavedBetween(startDate: startDate, endDate: endDate)
    }
    func getGoalsBetween(startDate: Date, endDate: Date) -> [Goal] {
        userProvider.current.getGoalsBetween(startDate: startDate, endDate: endDate)
    }
}
#endif
