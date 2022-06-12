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

struct Constants {
    /// Tag id for the hud view, so it can be retrieved later without keeping a reference to it, this number is built based on the position of each letter of "HudView" in the alphabet
    /// H 8, U 22, D 4, V 23, i 9, E 5, W 24
    static let hudViewTag = 8224239524
}

struct InfoConstants {
    static let kFirebaseDataUrl = "kFirebaseDataUrl"
}
