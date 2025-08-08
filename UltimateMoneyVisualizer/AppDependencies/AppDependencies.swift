// This file is disabled because the DI types are embedded in `UltimateMoneyVisualizerApp.swift` to ensure they're compiled.
#if false
import Foundation
import SwiftUI

// MARK: - Protocols

protocol UserProviding {
    var current: User { get }
}

protocol NavigationCoordinating {
    var currentTab: NavManager.Tabs { get set }
    func push(_ destination: NavManager.AllViews)
    func pop()
    func clear()
}

// MARK: - Default Providers

struct DefaultUserProvider: UserProviding {
    var current: User { User.main }
}

final class NavCoordinator: NavigationCoordinating {
    private let nav = NavManager.shared
    var currentTab: NavManager.Tabs {
        get { nav.currentTab }
        set { nav.currentTab = newValue }
    }
    func push(_ destination: NavManager.AllViews) { nav.appendCorrectPath(newValue: destination) }
    func pop() { nav.popFromCorrectPath() }
    func clear() { nav.clearCurrentPath() }
}

// MARK: - AppDependencies

@MainActor
final class AppDependencies: ObservableObject {
    static let shared = AppDependencies()

    let userProvider: UserProviding
    let navigator: NavigationCoordinating
    let earningsRepository: EarningsRepository

    init(userProvider: UserProviding = DefaultUserProvider(),
         navigator: NavigationCoordinating = NavCoordinator(),
         earningsRepository: EarningsRepository? = nil) {
        self.userProvider = userProvider
        self.navigator = navigator
        self.earningsRepository = earningsRepository ?? DefaultEarningsRepository(userProvider: userProvider)
    }
}
#endif
