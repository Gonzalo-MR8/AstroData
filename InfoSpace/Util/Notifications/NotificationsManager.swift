//
//  NotificationsManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/11/23.
//

import UIKit
import UserNotifications

class NotificationsManager {
  private func requestNotificationsPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted == true, error == nil {
        print("Configure Notifications")
      }
    }
  }

  func checkNotificationsPermission() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .notDetermined:
        // The user has not yet made a choice about whether the app can schedule notifications.
        self.requestNotificationsPermission()
      case .denied:
        // TO DO Alert 
        if let url = URL(string: UIApplication.openSettingsURLString) {
          CustomNavigationController.instance.openUrl(url)
        }
      case .authorized, .provisional:
        print("Configure Notifications")
      case .ephemeral:
        self.requestNotificationsPermission()
      @unknown default:
        self.requestNotificationsPermission()
      }
    }
  }
}
