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
    @Published var lastPath: PossiblePaths = .none
    @Published var scrollViewID = UUID()
    
    @Published var scrollProxy: ScrollViewProxy?
    
    
    enum AllViews: Hashable {
        case home, settings, today, confirmToday
    }

    func clearAllPaths() {
        homeNavPath = .init()
        settingsNavPath = .init()
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
        }
    }

    enum Tabs: String, Hashable, CustomStringConvertible, Equatable {
        var description: String { rawValue.capitalized }
        case settings, expenses, home, shifts, today, addShifts, allItems
    }

    enum PossiblePaths: Hashable {
        case home
        case settings
        case today
        case none
    }
}
