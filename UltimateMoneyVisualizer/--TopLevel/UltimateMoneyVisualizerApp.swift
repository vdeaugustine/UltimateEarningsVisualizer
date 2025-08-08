//
//  UltimateMoneyVisualizerApp.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import SwiftUI
import UserNotifications

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
                .environmentObject(navManager)
                .environmentObject(user)
                
        }
    }
}
