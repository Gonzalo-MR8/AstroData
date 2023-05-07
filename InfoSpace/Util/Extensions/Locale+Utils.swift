//
//  Locale+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 6/5/23.
//

import Foundation

enum CustomLanguage: String, CaseIterable {
    case english = "en"
    case spanish = "es"
}

extension Locale {
    static var currentLanguage: CustomLanguage? {
        guard let language = preferredLanguages.first else { return nil }

        var customLanguage: CustomLanguage?

        let prefix = language.prefix(2)

        customLanguage = CustomLanguage.allCases.first(where: { $0.rawValue == prefix })

        return customLanguage
    }
}
