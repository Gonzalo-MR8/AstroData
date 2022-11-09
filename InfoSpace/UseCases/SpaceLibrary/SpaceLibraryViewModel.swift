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
    
    func getSpaceLibraryItemsBegin(page: Int, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsDefault WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems = spaceLibraryItems
                completion(.success(()))
            }
        })
    }
    
    func getSpaceLibraryItemsFilters(filters: SpaceLibraryFilters, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getLibraryFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsFilters WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems = spaceLibraryItems
                completion(.success(()))
            }
        })
    }
    
    func getSpaceLibraryItemsBeginNewPage(page: Int, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsBeginNewPage WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
                completion(.success(()))
            }
        })
    }
    
    func getSpaceLibraryItemsFiltersNewPage(filters: SpaceLibraryFilters, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getLibraryFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsFiltersNewPage WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
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
