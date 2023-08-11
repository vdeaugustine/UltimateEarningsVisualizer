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

    @Published var homeNavPath: NavigationPath = .init()
    @Published var settingsNavPath: NavigationPath = .init()
    @Published var todayViewNavPath: NavigationPath = .init()
    @Published var allItemsNavPath: NavigationPath = .init()
    @Published var lastPath: PossiblePaths = .none
    @Published var scrollViewID = UUID()

    @Published var focusedPath: NavigationPath? = nil

    @Published var currentTab: Tabs = .newHome

    @Published var scrollProxy: ScrollViewProxy?

    func appendCorrectPath(newValue: AllViews) {
        switch currentTab {
            case .settings:
                settingsNavPath.append(newValue)
            case .today:
                todayViewNavPath.append(newValue)
            case .allItems:
                allItemsNavPath.append(newValue)
            case .newHome:
                homeNavPath.append(newValue)
            default:
                break
        }
    }

    enum AllViews: Hashable {
        case home, settings, today, confirmToday, stats, wage(Wage), expense(Expense), goal(Goal), newItemCreation
        case allTimeBlocks
        case timeBlockDetail(TimeBlock)
        case condensedTimeBlock(CondensedTimeBlock)
        case createExpense, createGoal, createSaved
        case shift(Shift)
    }

    func clearAllPaths() {
        homeNavPath = .init()
        settingsNavPath = .init()
        todayViewNavPath = .init()
    }

    func sameTabTapped(tabTapped: Tabs) {
        switch tabTapped {
            case .settings:
                break
            case .expenses:
                break
            case .home:
                homeNavPath = .init()
                scrollViewID = UUID()
            case .shifts:
                break
            case .today:
                break
            case .addShifts:
                break
            case .allItems:
                break
            case .newHome:
                break
        }
    }

    enum Tabs: String, Hashable, CustomStringConvertible, Equatable {
        var description: String { rawValue.capitalized }
        case settings, expenses, home, shifts, today, addShifts, allItems

        // testing
        case newHome
    }

    enum PossiblePaths: Hashable {
        case home
        case settings
        case today
        case none
    }

    enum TodayViewDestinations: Hashable {
        case payoffQueue,
             confirmShift,
             timeBlockDetail(TimeBlock),
             newTimeBlock(TodayShift),
             goalDetail(Goal),
             expenseDetail(Expense)
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
            case .home:
                NewHomeView()
            case .settings:
                SettingsView()
            case .stats:
                StatsView()
            case let .wage(wage):
                WageView(wage: wage)
            case let .expense(expense):
                ExpenseDetailView(expense: expense)
            case let .goal(goal):
                GoalDetailView(goal: goal)
            case .allTimeBlocks:
                AllTimeBlocksView()
            case .newItemCreation:
                NewItemCreationView()
            case let .timeBlockDetail(block):
                TimeBlockDetailView(block: block)
            case let .condensedTimeBlock(block):
                CondensedTimeBlockView(block: block)
            case .createGoal:
                CreateGoalView().environmentObject(NewItemViewModel.shared)
            case .createExpense:
                CreateExpenseView().environmentObject(NewItemViewModel.shared)
            case .createSaved:
                CreateSavedView().environmentObject(NewItemViewModel.shared)
            case let .shift(shift):
                ShiftDetailView(shift: shift)

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
