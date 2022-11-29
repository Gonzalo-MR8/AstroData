//
//  SpaceLibraryViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import Foundation

typealias SpaceLibraryData = (SpaceLibraryItems, SLastPageItem)

enum Order: Equatable {
    case highestToLowest
    case lowestToHighest
}

final class SpaceLibraryViewModel {
    
    private var spaceLibraryItems: SpaceLibraryItems!
    private var slItem: SLastPageItem!
    private var order: Order = .highestToLowest
    
    init(spaceLibraryData: SpaceLibraryData) {
        self.spaceLibraryItems = spaceLibraryData.0
        self.slItem = spaceLibraryData.1
        orderSpaceItems(order: order)
    }
    
    func getSpaceLibraryItemsBegin(completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        let page: String!
        
        switch order {
        case .highestToLowest:
            if let url = URL(string: slItem.collection.links.first?.href ?? "") {
                page = url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage)
            } else {
                page = "1"
            }
        case .lowestToHighest:
            page = "1"
        }
        
        NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsDefault WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems = spaceLibraryItems
                self.orderSpaceItems(order: self.order)
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
    
    func getSpaceLibraryItemsBeginNewPage(page: String, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
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
    
    /*private func getLastPage(page: Int? = nil, filters: SpaceLibraryFilters? = nil, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        NasaLibraryDataManager.shared.getSLastPageItemDefault(completion: { result in
            switch result {
            case .failure(let error):
                print("getLastPage WS error: \(error)")
            case .success(let slItem):
                if let url = URL(string: slItem.collection.href) {
                    lastPage = Int(url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage) ?? "1")
                } else {
                    lastPage = 1
                }
            }
        })
    }*/
    
    private func orderSpaceItems(order: Order) {
        switch order {
        case .highestToLowest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated > $1.spaceItemsdatas.first!.dateCreated } )
        case .lowestToHighest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated < $1.spaceItemsdatas.first!.dateCreated } )
        }
    }
    
    func getNumberOfSpaceItems() -> Int {
        return spaceLibraryItems.collection.spaceItems.count
    }
    
    func getSpaceItem(position: Int) -> SpaceItem {
        return spaceLibraryItems.collection.spaceItems[position]
    }
}
