//
//  LocalNotificationManager.swift
//  Snappy Wins
//
//  Created by Marwan Elwaraki on 30/03/2020.
//  Copyright © 2020 marwan. All rights reserved.
//

import UIKit
import CoreData

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = LocalNotificationManager()
    var trigger:UNCalendarNotificationTrigger?
    var journalledToday = false
    var combinedCurrentDate = ""
    
    func requestPushNotificationsPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if granted {
//                    self.scheduleNotifications()
                }
            }
        }
    }
    
    func getTodaysDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d.M.YYYY"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let combinedDate = calendar.date(from:components)!
        combinedCurrentDate = formatter.string(from: combinedDate)
    }
    
    func scheduleNotifications() {
        //remove existing notifications
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        getTodaysDate()
        CoreDataManager().load("UserResponses") { [self] (returnedArray: [NSManagedObject]) in
            let entries = returnedArray as? [UserResponses]
            for entry in entries ?? [] {
                if entry.date == combinedCurrentDate {
                    journalledToday = true
                }
            }
        }
        
        for day in 0...4 {
            self.schedule(localNotifcation: self.getRandomNotification(), days: TimeInterval(day))
        }
    }
    
    func schedule(localNotifcation: LocalNotification?, days: TimeInterval) {
        
        guard let notification = localNotifcation else {
            return
        }
        
        let content = UNMutableNotificationContent()
        if let title = notification.title {
            content.title = title
        }
        if let body = notification.body {
            content.body = body
        }
        
        if journalledToday == true {
            journalledToday = false
            return
        }
        
        let day = Date().addingTimeInterval(days * 86400)
        let modifiedDay = Calendar.current.date(bySettingHour: Utilities.userHour, minute: Utilities.userMinute, second: 0, of: day)
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: modifiedDay!)
        self.trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create the request object.
        let notificationId = "\(days)InactiveNotif"
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: self.trigger)
        
        // Schedule the request.
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
}
