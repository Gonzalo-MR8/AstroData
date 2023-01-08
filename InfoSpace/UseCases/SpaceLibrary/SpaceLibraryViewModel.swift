//
//  SpaceLibraryViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import Foundation

typealias SpaceLibraryData = (SpaceLibraryItems, SLastPageItem)

enum Order {
    case highestToLowest
    case lowestToHighest
}

final class SpaceLibraryViewModel {
    
    private var spaceLibraryItems: SpaceLibraryItems!
    private var slItem: SLastPageItem!
    private var order: Order = .highestToLowest
    private var page: String = "1"

    init(spaceLibraryData: SpaceLibraryData) {
        self.spaceLibraryItems = spaceLibraryData.0
        orderSpaceItems(order: order)
        self.slItem = spaceLibraryData.1
        getDesiredPage()
    }
    
    // MARK: - Network Methods
    
    public func getSpaceLibraryItemsBegin(reset: Bool = false, changeOrder: Order? = nil, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        order = reset ? .highestToLowest : .lowestToHighest
        
        if let changeOrder = changeOrder {
            order = changeOrder
        }

        var initItems = false
        let group = DispatchGroup()
        
        group.enter()
        NasaLibraryDataManager.shared.getSLastPageItemDefault(completion: { result in
            switch result {
            case .failure(let error):
                print("getLastPage WS error: \(error)")
                group.leave()
            case .success(let slItemData):
                self.slItem = slItemData
                self.getDesiredPage()
                group.leave()
            }
        })
        group.wait()
        
        // We do this and take another page to prevent if the last page have only a few items
        if Int(page) ?? 0 >= 2, order == .highestToLowest {
            group.enter()
            NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
                switch result {
                case .failure(let error):
                    print("Space library WS error: \(error)")
                    group.leave()
                case .success(let spaceLibraryItems):
                    self.spaceLibraryItems = spaceLibraryItems
                    group.leave()
                }
            })
        } else {
            initItems = true
        }
        
        group.notify(queue: .main, execute: { [self] in
            getSpaceLibraryItemsBeginNewPage(completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let spaceLibraryItems):
                    if initItems {
                        self.spaceLibraryItems = spaceLibraryItems
                    }
                    completion(.success(()))
                }
            })
        })
    }
    
    public func getSpaceLibraryItemsFilters(filters: SpaceLibraryFilters, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        order = filters.order
        
        var initItems = false
        let group = DispatchGroup()
        
        group.enter()
        NasaLibraryDataManager.shared.getSLastPageItemFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let error):
                print("getLastPage WS error: \(error)")
                group.leave()
            case .success(let slItemData):
                self.slItem = slItemData
                self.getDesiredPage()
                group.leave()
            }
        })
        group.wait()
        
        // We do this and take another page to prevent if the last page have only a few items
        if Int(page) ?? 0 >= 2, order == .highestToLowest {
            group.enter()
            
            var pageUpdateFilters = filters
            pageUpdateFilters.page = page
            NasaLibraryDataManager.shared.getLibraryFilters(filters: pageUpdateFilters, completion: { result in
                switch result {
                case .failure(let error):
                    print("getSpaceLibraryItemsFilters WS error: \(error)")
                    group.leave()
                case .success(let spaceLibraryItems):
                    self.spaceLibraryItems = spaceLibraryItems
                    group.leave()
                }
            })
        } else {
            initItems = true
        }
        
        group.notify(queue: .main, execute: { [self] in
            getSpaceLibraryItemsFiltersNewPage(filters: filters, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let spaceLibraryItems):
                    if initItems {
                        self.spaceLibraryItems = spaceLibraryItems
                    }
                    completion(.success(()))
                }
            })
        })
    }
    
    public func getSpaceLibraryItemsBeginNewPage(completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
        calculateNextPage()
        
        NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsBeginNewPage WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
                self.orderSpaceItems(order: self.order)
                completion(.success(spaceLibraryItems))
            }
        })
    }
    
    public func getSpaceLibraryItemsFiltersNewPage(filters: SpaceLibraryFilters, completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
        calculateNextPage()
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        NasaLibraryDataManager.shared.getLibraryFilters(filters: pageUpdateFilters, completion: { result in
            switch result {
            case .failure(let error):
                print("getSpaceLibraryItemsFiltersNewPage WS error: \(error)")
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
                self.orderSpaceItems(order: self.order)
                completion(.success(spaceLibraryItems))
            }
        })
    }
    
    public func canLoadMoreData() -> Bool {
        guard let pageInt = Int(page), pageInt > 1 else { return false }
        
        if order == .highestToLowest, pageInt == 1 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Private Methods

    private func getDesiredPage() {
        page = "1"
        
        if let stringUrl = slItem.collection.getPrevLink(), let url = URL(string: stringUrl),
           let page = url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage),
           order == .highestToLowest {
            self.page = page
        }
    }
    
    private func calculateNextPage() {
        guard let pageInt = Int(page), pageInt > 1 else { return }
        
        switch order {
        case .highestToLowest:
            page = String(pageInt - 1)
        case .lowestToHighest:
            page = String(pageInt + 1)
        }
    }
    
    private func orderSpaceItems(order: Order) {
        switch order {
        case .highestToLowest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated > $1.spaceItemsdatas.first!.dateCreated } )
        case .lowestToHighest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated < $1.spaceItemsdatas.first!.dateCreated } )
        }
    }
    
    // MARK: - Public Methods
    
    public func getNumberOfSpaceItems() -> Int {
        let count = spaceLibraryItems.collection.spaceItems.count
        
        // Check if only exists one page
        guard let stringUrl = spaceLibraryItems.collection.links?.first?.href, let url = URL(string: stringUrl),
              let strPage = url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage),
              let intPage = Int(strPage) else {
            return count
        }
        
        if count % 2 == 0, intPage >= Int(page) ?? 1 {
            return count
        } else {
            return count - 1
        }
    }
    
    public func getSpaceItem(position: Int) -> SpaceItem {
        return spaceLibraryItems.collection.spaceItems[position]
    }
}
