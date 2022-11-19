//
//  SpaceLibraryItems.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/10/22.
//

import Foundation

// MARK: - SpaceLibraryItems
struct SpaceLibraryItems: Codable {
    var collection: Collection
}

// MARK: - Collection
struct Collection: Codable {
    let version: String
    let href: String
    var spaceItems: [SpaceItem]
    let links: [CollectionLink]?
    
    enum CodingKeys: String, CodingKey {
        case version, href
        case spaceItems = "items"
        case links
    }
}

// MARK: - Item
struct SpaceItem: Codable {
    let href: String
    let data: [SpaceItemData]
    let links: [ItemLink]?
}

// MARK: - Datum
struct SpaceItemData: Codable {
    let center: String?
    let title, nasaID: String
    let mediaType: MediaType
    let keywords: [String]?
    let dateCreated: Date
    let description508, secondaryCreator: String?
    let description: String?
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
        case album, photographer, location, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.center = try container.decodeIfPresent(String.self, forKey: .center)
        self.title = try container.decode(String.self, forKey: .title)
        self.nasaID = try container.decode(String.self, forKey: .nasaID)
        self.mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        self.keywords = try container.decodeIfPresent([String].self, forKey: .keywords)
        
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
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.album = try container.decodeIfPresent([String].self, forKey: .album)
        self.photographer = try container.decodeIfPresent(String.self, forKey: .photographer)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
    }
}

// MARK: - MediaType
enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
    case audio = "audio"
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let href: String
    let rel: String
    let render: MediaType?
}

// MARK: - CollectionLink
struct CollectionLink: Codable {
    let rel, prompt: String
    let href: String
}
