//
//  AppDelegate.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 24/5/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = CustomNavigationController.instance.configure()
        
        return true
    }


}

