//
//  SpaceItemDetailViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import Foundation

final class SpaceItemDetailViewModel {
    
    private let services: NasaLibraryServiceable
    
    private var spaceItem: SpaceItem
    private var mediaURLs: [String]?
    
    private let paths: [String] = ["orig.jpg", "orig.jpeg", "orig.png"]
    private let origPathExtensionLength: Int = 8
    
    init(spaceItem: SpaceItem) {
        self.spaceItem = spaceItem
        self.services = NasaLibraryServices()
    }
    
    func getMediaURLs() async throws {
      self.mediaURLs = try await services.getMediaURLs(jsonUrl: spaceItem.href)
    }
    
    public func getSpaceItemData() -> SpaceItemData {
        return spaceItem.spaceItemsdatas.first!
    }
    
    public func getSpaceItemLinks() -> ItemLink? {
        return spaceItem.links?.first
    }
    
    public func getVideoUrl() -> String {
        return mediaURLs?.first(where: { NSString(string: $0).pathExtension == "mp4" }) ?? ""
    }
    
    public func getAudioUrl() -> String {
        return mediaURLs?.first(where: { NSString(string: $0).pathExtension == "mp3" }) ?? ""
    }
    
    public func getHighDefinitionImage() -> String? {
        var highDefinitionImage: String?
        
        paths.forEach({ path in
            if let imageUrl = mediaURLs?.first(where: { NSString(string: $0).substring(from: $0.count - origPathExtensionLength).lowercased() == path }) {
                highDefinitionImage = imageUrl
                return
            }
        })
        
       return highDefinitionImage
    }
}
