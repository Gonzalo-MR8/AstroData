//
//  Localizable.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/1/23.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
