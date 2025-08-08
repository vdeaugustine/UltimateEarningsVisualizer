//
//  UltimateMoneyVisualizerApp.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import SwiftUI
import UserNotifications

// MARK: - Lightweight DI (embedded for now)

protocol UserProviding {
    var current: User { get }
}

struct DefaultUserProvider: UserProviding {
    var current: User { User.main }
}

protocol NavigationCoordinating {
    var currentTab: NavManager.Tabs { get set }
    func push(_ destination: NavManager.AllViews)
    func pop()
    func clear()
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

private struct DependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies = .shared
}

extension EnvironmentValues {
    var dependencies: AppDependencies {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 🔔 Ask for notification permissions on launch
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🔔 Notification auth error: \(error.localizedDescription)")
            }
            if granted {
                print("🔔 Notifications authorized")
                // Schedule a daily reminder at a reasonable default time
                DispatchQueue.main.async {
                    NotificationManager.scheduleDailyNotification()
                }
            } else {
                print("🔔 Notifications not authorized")
            }
        }
        
        User.main.addNewVisit()
        do {
            try PayPeriod.createNewIfCurrentHasPassed()
        } catch {
            print("Error in app delegate ")
        }
        
//        User.main.instantiateExampleItems(context: User.main.getContext())
        // TODO: Get rid of this
//        DebugOperations.deleteAll()
        
        return true
    }
}



@main
struct UltimateMoneyVisualizerApp: App {
    
    let persistenceController = PersistenceController.shared
    let context = PersistenceController.context
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var navManager = NavManager.shared
    @StateObject private var user = User.main

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
                .environment(\.dependencies, AppDependencies.shared)
                .environmentObject(navManager)
                .environmentObject(user)
                
        }
    }
}
