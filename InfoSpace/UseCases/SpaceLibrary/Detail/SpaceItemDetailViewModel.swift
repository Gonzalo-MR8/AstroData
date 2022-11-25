//
//  SpaceItemDetailViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import Foundation

final class SpaceItemDetailViewModel {
    
    private var spaceItem: SpaceItem!
    private var mediaURLs: [String]!
    
    init(spaceItem: SpaceItem) {
        self.spaceItem = spaceItem
    }
    
    func getMediaURLs(completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getMediaURLs(jsonUrl: spaceItem.href, completion: { result in
            switch result {
            case .failure(let error):
                print("getMediaURLs WS error: \(error)")
                completion(.failure(error))
            case .success(let strings):
                self.mediaURLs = strings
                completion(.success(()))
            }
        })
    }
    
    public func getSpaceItemData() -> SpaceItemData {
        return spaceItem.spaceItemsdatas.first!
    }
    
    public func getSpaceItemLinks() -> ItemLink? {
        return spaceItem.links?.first
    }
    
    public func getVideoUrl() -> String {
        let url = mediaURLs.first(where: { NSString(string: $0).pathExtension == "mp4" }) ?? ""        
        return url
    }
}
