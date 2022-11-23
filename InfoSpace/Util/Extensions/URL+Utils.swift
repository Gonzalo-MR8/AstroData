//
//  URL+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import Foundation

extension URL {
    init?(imageString: String) {
        if let url = URL(string: imageString) {
            self = url
        } else {
            let replacedString = imageString.replacingOccurrences(of: " ", with: "%20")
            
            if let url = URL(string: replacedString) {
                self = url
            } else {
                let replacedString = imageString.replacingOccurrences(of: " ", with: "+")
                
                if let url = URL(string: replacedString) {
                    self = url
                } else {
                    return nil
                }
            }
        }
    }
}
