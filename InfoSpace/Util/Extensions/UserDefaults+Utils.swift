//
//  UserDefaults+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 6/5/23.
//

import Foundation

// MARK: - Values

extension UserDefaults {
    struct UserDefaultKeys {
        static let kApodAlertNoShowAgain    = "ApodAlertNoShowAgain"
        static let kSearchAlertNoShowAgain  = "SearchAlertNoShowAgain"
        static let kSpaceLAlertNoShowAgain  = "SpaceLAlertNoShowAgain"
    }

    // Apod Alert No Show Again

    var apodAlertNoShowAgain: Bool {
        get {
            guard let deviceUDID = value(forKey: UserDefaultKeys.kApodAlertNoShowAgain) as? Bool else { return false }

            return deviceUDID
        }
        set {
            setValue(newValue, forKey: UserDefaultKeys.kApodAlertNoShowAgain)

            synchronize()
        }
    }

    // Search Alert No Show Again

    var searchAlertNoShowAgain: Bool {
        get {
            guard let deviceUDID = value(forKey: UserDefaultKeys.kSearchAlertNoShowAgain) as? Bool else { return false }

            return deviceUDID
        }
        set {
            setValue(newValue, forKey: UserDefaultKeys.kSearchAlertNoShowAgain)

            synchronize()
        }
    }

    // space Library Alert No Show Again

    var spaceLAlertNoShowAgain: Bool {
        get {
            guard let deviceUDID = value(forKey: UserDefaultKeys.kSpaceLAlertNoShowAgain) as? Bool else { return false }

            return deviceUDID
        }
        set {
            setValue(newValue, forKey: UserDefaultKeys.kSpaceLAlertNoShowAgain)

            synchronize()
        }
    }
}
