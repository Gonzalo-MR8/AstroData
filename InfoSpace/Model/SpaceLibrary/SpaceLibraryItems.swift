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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try container.decode(String.self, forKey: .version)
        self.href = try container.decode(String.self, forKey: .href)
        
        /// Remove unaccess items, the access of this items is denied by de NASA API
        var auxSpaceItems: [SpaceItem] = try container.decode([SpaceItem].self, forKey: .spaceItems)
        auxSpaceItems.removeAll(where: { $0.spaceItemsdatas.first?.mediaType == .video && URL(completedString: $0.links?.first?.href ?? "") == nil })
        self.spaceItems = auxSpaceItems
        
        self.links = try container.decodeIfPresent([CollectionLink].self, forKey: .links)
    }
    
    /// This method avoid duplicated items
    public mutating func appendNewItemsToSpaceItems(spaceItems: [SpaceItem]) {
        spaceItems.forEach({ item in
            self.spaceItems.removeAll(where: { $0.equalItem(spaceItem: item) })
        })
        
        self.spaceItems.append(contentsOf: spaceItems)
    }
}

// MARK: - SpaceItem
struct SpaceItem: Codable {
    let href: String
    let spaceItemsdatas: [SpaceItemData]
    let links: [ItemLink]?
    
    enum CodingKeys: String, CodingKey {
        case href
        case spaceItemsdatas = "data"
        case links
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.href = try container.decode(String.self, forKey: .href)
        self.spaceItemsdatas = try container.decode([SpaceItemData].self, forKey: .spaceItemsdatas)
        self.links = try container.decodeIfPresent([ItemLink].self, forKey: .links)
    }
    
    public func equalItem(spaceItem: SpaceItem) -> Bool {
        return spaceItemsdatas.contains(where: { $0.nasaID == spaceItem.spaceItemsdatas.first?.nasaID })
    }
}

// MARK: - SpaceItemData
struct SpaceItemData: Codable {
    let title, nasaID: String
    let mediaType: MediaType
    let keywords, album: [String]?
    let dateCreated: Date
    let secondaryCreator, description, photographer, location, center: String?

    enum CodingKeys: String, CodingKey {
        case center, title
        case nasaID = "nasa_id"
        case mediaType = "media_type"
        case keywords
        case dateCreated = "date_created"
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
