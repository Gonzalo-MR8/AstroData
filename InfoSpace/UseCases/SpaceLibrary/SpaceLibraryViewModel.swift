//
//  SpaceLibraryViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import Foundation

final class SpaceLibraryViewModel {
    
    private var spaceLibraryItems: SpaceLibraryItems!
    
    init(spaceLibraryItems: SpaceLibraryItems) {
        self.spaceLibraryItems = spaceLibraryItems
    }
    
    func getSpaceLibraryItemsBegin(completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getLibraryBegin(completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsBegin WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems = spaceLibraryItems
                completion(.success(()))
            }
        })
    }
    
    func getNumberOfSpaceItems() -> Int {
        return spaceLibraryItems.collection.spaceItems.count
    }
    
    func getSpaceItem(position: Int) -> SpaceItem {
        return spaceLibraryItems.collection.spaceItems[position]
    }
}
