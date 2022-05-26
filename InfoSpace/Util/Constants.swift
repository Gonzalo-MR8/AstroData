//
//  Constants.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/5/22.
//

import Foundation

extension NSNotification.Name {
    // Reachability
    static let ReachabilityChanged = Notification.Name("ReachabilityChanged")
    
    // Background/foreground
    static let AppWillEnterForeground = Notification.Name("AppWillEnterForeground")
    static let AppDidEnterBackground  = Notification.Name("AppDidEnterBackground")
}
