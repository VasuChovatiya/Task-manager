//
//  NotificationManager.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 03/12/23.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    //MARK: - Shared Instance
    static let shared = NotificationManager()
    
    
    //MARK: - Properties
    let notificationCeneter = UNUserNotificationCenter.current()
    
    //MARK: - Init
    override init() {
        super.init()
        notificationCeneter.delegate = self
    }
    
    
    //MARK: - Functions
    func requestAuthentication(onCompletion: @escaping (_ status: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { didAllowed, error in
            if let error = error {
                DLog("error while authorizing permission: - \(error.localizedDescription)")
                onCompletion(false)
            } else {
                onCompletion(true)
            }
        }
    }
    
    func getAuthorizeStatus(onCompletion: @escaping (_ status: UNAuthorizationStatus) -> ()) {
        notificationCeneter.getNotificationSettings { setting in
            onCompletion(setting.authorizationStatus)
        }
    }
    
    
    
    func scheduleDailyNotification(id: String, title: String, body: String, date: Date, onCompletion: @escaping (_ status: Bool) -> ()) {
        removePendingNotficationRequests(for: id) { _ in
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = id
            content.title = title
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            
            self.notificationCeneter.add(request) { error in
                if let error = error {
                    DLog("Error while adding notification request: - \(error)")
                    onCompletion(false)
                } else {
                    onCompletion(true)
                }
            }
        }
        
        
        
    }
    
    func scheduleMonthlyNotification(id: String, title: String, body: String, date: Date, onCompletion: @escaping (_ status: Bool) -> ()) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = id
        content.title = title
        content.sound = .default
        DLog("date for scheduling notfication: - \(components)")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        
        self.notificationCeneter.add(request) { error in
            if let error = error {
                DLog("Error while adding notification request: - \(error)")
                onCompletion(false)
            } else {
                onCompletion(true)
            }
        }
    }
    
    
    func scheduleYearlyNotification(id: String, title: String, body: String, date: Date, onCompletion: @escaping (_ status: Bool) -> ()) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: date)
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = id
        content.title = title
        content.sound = .default
        DLog("date for scheduling notfication: - \(components)")
        DLog("date for scheduling notfication: - \(components)")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        
        self.notificationCeneter.add(request) { error in
            if let error = error {
                DLog("Error while adding notification request: - \(error)")
                onCompletion(false)
            } else {
                onCompletion(true)
            }
        }
    }
    
    
    
    
    func removePendingNotficationRequests(for identifier: String, onCompletion: @escaping (_ status: Bool) -> ()) {
        self.notificationCeneter.getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification: UNNotificationRequest in notificationRequests {
                if notification.identifier == identifier {
                    identifiers.append(notification.identifier)
                }
            }
            self.notificationCeneter.removePendingNotificationRequests(withIdentifiers: identifiers)
            
            onCompletion(true)
        }
    }
}






//MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

