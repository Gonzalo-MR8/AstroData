//
//  SpaceLibraryItem.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/10/22.
//

import Foundation

// MARK: - SpaceLibraryItems
struct SpaceLibraryItems: Codable {
    let collection: Collection
}

// MARK: - Collection
struct Collection: Codable {
    let version: String
    let href: String
    let spaceItems: [SpaceItem]
    let links: [CollectionLink]
    
    enum CodingKeys: String, CodingKey {
        case version, href
        case spaceItems = "items"
        case links
    }
}

// MARK: - Item
struct SpaceItem: Codable {
    let href: String
    let data: [Datum]
    let links: [ItemLink]
}

// MARK: - Datum
struct Datum: Codable {
    let center: Center
    let title, nasaID: String
    let mediaType: MediaType
    let keywords: [String]
    let dateCreated: Date
    let description508, secondaryCreator: String?
    let datumDescription: String
    let album: [String]?
    let photographer, location: String?

    enum CodingKeys: String, CodingKey {
        case center, title
        case nasaID = "nasa_id"
        case mediaType = "media_type"
        case keywords
        case dateCreated = "date_created"
        case description508 = "description_508"
        case secondaryCreator = "secondary_creator"
        case datumDescription = "description"
        case album, photographer, location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.center = try container.decode(Center.self, forKey: .center)
        self.title = try container.decode(String.self, forKey: .title)
        self.nasaID = try container.decode(String.self, forKey: .nasaID)
        self.mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        self.keywords = try container.decode([String].self, forKey: .keywords)
        
        let formatter = DateFormatter.dateFormatterUTC
        formatter.dateFormat = Constants.kLongDateFormat
        
        let strDate = try container.decode(String.self, forKey: .dateCreated)
        
        if let date = formatter.date(from: strDate) {
            self.dateCreated = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dateCreated,
                                                   in: container,
                                                   debugDescription: "Date string \(strDate) does not match format expected \(Constants.kLongDateFormat)")
        }
        
        self.description508 = try container.decodeIfPresent(String.self, forKey: .description508)
        self.secondaryCreator = try container.decodeIfPresent(String.self, forKey: .secondaryCreator)
        self.datumDescription = try container.decode(String.self, forKey: .datumDescription)
        self.album = try container.decodeIfPresent([String].self, forKey: .album)
        self.photographer = try container.decodeIfPresent(String.self, forKey: .photographer)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
}

enum Center: String, Codable {
    case hq = "HQ"
    case jpl = "JPL"
    case jsc = "JSC"
    case maf = "MAF"
    case msfc = "MSFC"
    case ssc = "SSC"
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
    case audio = "audio"
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let href: String
    let rel: Rel
    let render: MediaType?
}

enum Rel: String, Codable {
    case captions = "captions"
    case preview = "preview"
}

// MARK: - CollectionLink
struct CollectionLink: Codable {
    let rel, prompt: String
    let href: String
}
