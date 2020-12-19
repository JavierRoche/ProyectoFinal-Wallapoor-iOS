//
//  AppDelegate+Notifications.swift
//  Wallapobre
//
//  Created by APPLE on 18/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//
/*
import UIKit
import UserNotifications
import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Para registrarnos a las notificaciones push hay que usar unas funciones del Delegate
    func registerPushNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            /// Solicitamos el permiso a los tipos de notificacion
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
            
        } else {
            /// Solicitamos el permiso a los tipos de notificacion
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    /// Salta cuando nos registremos con una notificacion
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().subscribe(toTopic: "ALL")
    }
    
    /// Presentamos una notificacion push
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        processNotification(notification)
    }
    
    /// Nos llega una notificacion push
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        processNotification(response.notification)
    }
    
    private func processNotification(_ notification: UNNotification) {
        // TODO
    }
}
*/
