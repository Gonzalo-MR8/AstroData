//
//  DateFormatter+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/6/22.
//

import Foundation

extension DateFormatter {
    private static let kEn_US_POSIX = "en_US_POSIX"
    private static let kUTCTimeZone = "UTC"
    
    static var dateFormatterUTC: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: kEn_US_POSIX)
        
        let timeZoneGMT = TimeZone(abbreviation: kUTCTimeZone)
        dateFormatter.timeZone = timeZoneGMT
        
        return dateFormatter
    }
    
    static var dateFormatterLocale: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter
    }
}
