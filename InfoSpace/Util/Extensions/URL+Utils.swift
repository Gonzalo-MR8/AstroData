//
//  URL+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import Foundation

extension URL {
    init?(completedString: String) {
        if let url = URL(string: completedString) {
            self = url
        } else {
            let replacedString = completedString.replacingOccurrences(of: " ", with: "%20")
            
            if let url = URL(string: replacedString) {
                self = url
            } else {
                let replacedString = completedString.replacingOccurrences(of: " ", with: "+")
                
                if let url = URL(string: replacedString) {
                    self = url
                } else {
                    return nil
                }
            }
        }
    }
}
