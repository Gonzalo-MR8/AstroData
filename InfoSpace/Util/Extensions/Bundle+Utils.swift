//
//  Bundle+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/6/22.
//

import Foundation

extension Bundle {
    public static func string(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}
