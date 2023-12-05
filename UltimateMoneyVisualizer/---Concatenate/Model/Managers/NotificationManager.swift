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
        content.title = "Teddy is a very good ted dog."
        content.body = "Tiana is a very good red dog."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 57
        let date = Date.now.addMinutes(10 / 60)
        
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling daily notification:", error)
            } else {
                print("Daily notification scheduled.")
                print("Should notify at \(date)\n\(comps)")
            }
        }
    }
    
    
}
