//
//  APOD.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import Foundation

enum APODMediaType: String, Decodable {
    case image
    case video
}

struct APOD: Decodable {
    let copyright: String?
    let date: Date
    let hdUrl: String?
    let mediaType: APODMediaType
    let serviceVersion, title, explanation: String
    let thumbUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case thumbUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let formatter = DateFormatter.dateFormatterUTC
        formatter.dateFormat = Constants.kShortDateFormat
        
        let strDate = try container.decode(String.self, forKey: .date)
        
        if let date = formatter.date(from: strDate) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                   in: container,
                                                   debugDescription: "Date string \(strDate) does not match format expected \(Constants.kShortDateFormat)")
        }

        explanation = try container.decode(String.self, forKey: .explanation)
        mediaType = try container.decode(APODMediaType.self, forKey: .mediaType)
        serviceVersion = try container.decode(String.self, forKey: .serviceVersion)
        title = try container.decode(String.self, forKey: .title)
        thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
        
        do {
            copyright = try container.decode(String.self, forKey: .copyright)
        } catch {
            copyright = nil
        }
        
        switch mediaType {
        case .image:
            hdUrl = try container.decode(String.self, forKey: .hdurl)
        case .video:
            hdUrl = nil
        }
    }

    /// This init is to avoid blocking the rest of the app when apod is unavailable, and to be able to continue using app.
    init()  {
        date = Date()
        explanation = "The server is temporarily unable to service your request due to maintenance downtime or capacity problems. Please try again later."
        mediaType = .image
        serviceVersion = ""
        title = "Service Unavailable"
        thumbUrl = ""
        copyright = nil
        hdUrl = nil
    }
}
