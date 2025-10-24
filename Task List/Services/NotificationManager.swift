//
//  NotificationManager.swift
//  Task List
//
//  Created by GamzeAkyuz on 22.10.2025.
//

import Foundation
import UserNotifications

enum NotificationManager {
    
    static let shared = UNUserNotificationCenter.current()
    
    static func requestPermission() {
        shared.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    static func scheduleNotification(for task: Task) {
        
        
        shared.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("Error: Cannot schedule notification. Permission not granted.")
                return
            }
            
            
            guard let dueDate = task.dueDate, !task.isCompleted else {
                print("Cannot schedule notification: Task is either completed or has no due date.")
                NotificationManager.cancelNotification(for: task)
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Task Reminder!"
            content.body = task.title
            content.sound = .default
            
            if let imageURL = Bundle.main.url(forResource: "icon", withExtension: "png") {
                do {
                    let attachment = try UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
                    
                    // 3. Eki içeriğe ata
                    content.attachments = [attachment]
                    
                } catch {
                    print("Hata: Bildirim eki oluşturulamadı. \(error.localizedDescription)")
                }
            }
            
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: dueDate)
            
            dateComponents.hour = 8
            dateComponents.minute = 0
            
            guard let triggerDate = Calendar.current.date(from: dateComponents) else {
                print("Error: Could not create trigger date from components.")
                return
            }
            
            if triggerDate < Date() {
                print("Warning: Notification time \(triggerDate) is in the past. Not scheduling.")
                return
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: task.id.uuidString,
                                                content: content,
                                                trigger: trigger)
            
            shared.add(request) { error in
                if let error = error {
                    print("Error scheduling notification for task \(task.id): \(error.localizedDescription)")
                } else {
                    print("Successfully scheduled notification for task: \(task.title)")
                }
            }
        }
    }
    
    static func cancelNotifications(for task: Task) {
        shared.removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        print("Cancelled notification for task: \(task.title)")
    }
    
    static func cancelNotification(for task: Task) {
        cancelNotifications(for: task)
    }
}
