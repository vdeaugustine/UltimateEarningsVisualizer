//
//  NavManager.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/9/23.
//

import Foundation
import SwiftUI

// MARK: - NavManager

class NavManager: ObservableObject {
    static var shared: NavManager = NavManager()

    
    @Published var allItemsNavPath: NavigationPath = .init()
    @Published var currentTab: Tabs = .newHome
    @Published var focusedPath: NavigationPath? = nil
    @Published var homeNavPath: NavigationPath = .init()
    @Published var lastPath: PossiblePaths = .none
    @Published var scrollProxy: ScrollViewProxy?
    @Published var scrollViewID = UUID()
    @Published var settingsNavPath: NavigationPath = .init()
    @Published var todayViewNavPath: NavigationPath = .init()
    

    // MARK: - Methods

    
    func appendCorrectPath(newValue: AllViews) {
        switch currentTab {
            case .allItems:
                allItemsNavPath.append(newValue)
            case .newHome:
                homeNavPath.append(newValue)
            case .settings:
                settingsNavPath.append(newValue)
            case .today:
                todayViewNavPath.append(newValue)
            default:
                break
        }
        print("Now showing", "\(newValue)")

        let x = 1 < 2
        if x == true {
        }
    }

    func clearAllPaths() {
        homeNavPath = .init()
        settingsNavPath = .init()
        todayViewNavPath = .init()
    }

    func clearCurrentPath() {
        switch currentTab {
            case .allItems:
                allItemsNavPath = .init()
            case .newHome:
                homeNavPath = .init()
            case .settings:
                settingsNavPath = .init()
            case .today:
                todayViewNavPath = .init()
            default:
                break
        }
    }

    func makeCurrentPath(this newPath: NavigationPath) {
        switch currentTab {
            case .allItems:
                allItemsNavPath = newPath
            case .newHome:
                homeNavPath = newPath
            case .settings:
                settingsNavPath = newPath
            case .today:
                todayViewNavPath = newPath
            default:
                break
        }
    }

    func sameTabTapped(tabTapped: Tabs) {
        switch tabTapped {
            case .addShifts:
                break
            case .allItems:
                break
            case .expenses:
                break
            case .home:
                homeNavPath = .init()
                scrollViewID = UUID()
            case .newHome:
                homeNavPath = .init()
            case .settings:
                settingsNavPath = .init()
            case .shifts:
                break
            case .today:
                break
        }
    }

    

    // MARK: - Enums

    
    enum AllViews: Hashable {
        case allTimeBlocks
        case condensedTimeBlock(CondensedTimeBlock)
        case confirmToday
        case createExpense
        case createGoal
        case createSaved
        case createShift
        case enterWage
        case expense(Expense)
        case expenseContributions(Expense)
        case goal(Goal)
        case home
        case newItemCreation
        case payPeriodDetail(PayPeriod)
        case payPeriods
        case purchasePage
        case regularSchedule
        case saved(Saved)
        case settings
        case shift(Shift)
        case shiftAllocSheet_Expense(Shift, Expense)
        case stats
        case tagDetail(Tag)
        case timeBlockDetail(TimeBlock)
        case today
        case wage(Wage)
    }

    enum PossiblePaths: Hashable {
        case home
        case settings
        case today
        case none
    }

    enum Tabs: String, Hashable, CustomStringConvertible, Equatable {
        var description: String { rawValue.capitalized }

        case addShifts
        case allItems
        case expenses
        case home
        case newHome // testing
        case settings
        case shifts
        case today
    }

    enum TodayViewDestinations: Hashable {
        case confirmShift
        case expenseDetail(Expense)
        case goalDetail(Goal)
        case newTimeBlock(TodayShift)
        case payoffQueue
        case timeBlockDetail(TimeBlock)
    }

    

    @ViewBuilder func getDestinationViewForTodayViewStack(destination: NavManager.TodayViewDestinations) -> some View {
        switch destination {
            case .confirmShift:
                ConfirmTodayShift().environmentObject(TodayViewModel.main)
            case .payoffQueue:
                PayoffQueueView()
            case let .timeBlockDetail(block):
                TimeBlockDetailView(block: block)
            case let .goalDetail(goal):
                GoalDetailView(goal: goal)
            case let .expenseDetail(expense):
                ExpenseDetailView(expense: expense)
            case let .newTimeBlock(todayShift):
                CreateNewTimeBlockView(todayShift: todayShift)
        }
    }

    
    @ViewBuilder func getDestinationViewForStack(destination: NavManager.AllViews) -> some View {
        switch destination {
            case .allTimeBlocks:
                AllTimeBlocksView()
            case let .condensedTimeBlock(block):
                CondensedTimeBlockView(block: block)
            case .createExpense:
                CreateExpenseView().environmentObject(NewItemViewModel.shared)
            case .createGoal:
                CreateGoalView().environmentObject(NewItemViewModel.shared)
            case .createSaved:
                CreateSavedView().environmentObject(NewItemViewModel.shared)
            case .createShift:
                NewShiftView()
            case .enterWage:
                EnterWageView()
            case let .expense(expense):
                ExpenseDetailView(expense: expense)
            case let .expenseContributions(expense):
                ContributionsForExpenseView(expense: expense)
            case let .goal(goal):
                GoalDetailView(goal: goal)
            case .home:
                NewHomeView()
            case .newItemCreation:
                NewItemCreationView()
            case let .payPeriodDetail(period):
                PayPeriodDetailView(payPeriod: period)
            case .payPeriods:
                PayPeriodsView()
            case .purchasePage:
                PurchasePage()
            case .regularSchedule:
                RegularScheduleView()
            case let .saved(saved):
                SavedDetailView(saved: saved)
            case .settings:
                SettingsView()
            case let .shift(shift):
                ShiftDetailView(shift: shift)
            case let .shiftAllocSheet_Expense(shift, expense):
                AddAllocationForExpenseView.ShiftAllocSheet(shift: shift, expense: expense)
            case .stats:
                StatsView()
            case let .tagDetail(tag):
                TagDetailView(tag: tag)
            case let .timeBlockDetail(block):
                TimeBlockDetailView(block: block)
            default:
                EmptyView()
        }
    }
}

extension NavigationPath {
    mutating func appendView(_ view: NavManager.AllViews) {
        append(view)
    }

    mutating func appendTodayView(_ view: NavManager.TodayViewDestinations) {
        append(view)
    }
}
