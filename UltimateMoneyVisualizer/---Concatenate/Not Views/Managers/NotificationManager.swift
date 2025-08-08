//
//  NotificationManager.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/16/23.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Stay on top of your earnings 💸"
        content.body = "Open the app to log shifts and track progress."
        content.sound = .default

        // Default to 9:00 AM local time; hour/minute only when repeats == true
        var comps = DateComponents()
        comps.hour = 9
        comps.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🔔 Failed to schedule daily notification: \(error.localizedDescription)")
            } else {
                print("🔔 Daily notification scheduled at \(comps.hour ?? 0):\(String(format: "%02d", comps.minute ?? 0))")
            }
        }
    }
    
    
}
