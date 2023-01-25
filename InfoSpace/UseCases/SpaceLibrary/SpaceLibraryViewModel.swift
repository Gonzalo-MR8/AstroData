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
    
    /// This method manages the reset button pressed and when you want to change only the order of the space items
    public func getSpaceLibraryItemsBegin(reset: Bool = false, changeOrder: Order? = nil, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        order = reset ? .highestToLowest : .lowestToHighest
        
        /// Change the order to a new order
        if let changeOrder = changeOrder {
            order = changeOrder
        }
        
        /// The onePage variable is used when the call has only 1 page to initialize the spaceLibraryItems variable and not add new items in the second call as if it came from more than one page.
        var onePage = false
        
        let group = DispatchGroup()
        
        /// This call gets the last page of the spaceItems, call to handle when you need to take the last or the first items depending on the order, it also works to know if the call has only 1 page or more
        group.enter()
        NasaLibraryDataManager.shared.getSLastPageItemDefault(completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                group.leave()
            case .success(let slItemData):
                self.slItem = slItemData
                self.getDesiredPage()
                group.leave()
            }
        })
        group.wait()
        
        /// If the order is from the highest to the lowest, the last page may have only a few items, so we take the last two pages to avoid this situation and also other similar ones, otherwise the user would not be able to scroll to get more items.
        if Int(page) ?? 0 >= 2, order == .highestToLowest {
            group.enter()
            NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    group.leave()
                case .success(let spaceLibraryItems):
                    self.spaceLibraryItems = spaceLibraryItems
                    group.leave()
                }
            })
        } else {
            onePage = true
        }
        
        group.notify(queue: .main, execute: { [self] in
            guard !onePage else {
                /// Get the one page
                NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let spaceLibraryItems):
                        self.spaceLibraryItems = spaceLibraryItems
                        self.orderSpaceItems(order: self.order)
                        completion(.success(()))
                    }
                })
                
                return
            }
            
            /// Get more items when comes more than 1 page
            getSpaceLibraryItemsBeginNewPage(completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success():
                    completion(.success(()))
                }
            })
        })
    }
    
    public func getSpaceLibraryItemsFilters(filters: SpaceLibraryFilters, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        order = filters.order
        
        /// The onePage variable is used when the call has only 1 page to initialize the spaceLibraryItems variable and not add new items in the second call as if it came from more than one page.
        var onePage = false
        
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        
        let group = DispatchGroup()
        
        /// This call gets the last page of the spaceItems, call to handle when you need to take the last or the first items depending on the order, it also works to know if the call has only 1 page or more
        group.enter()
        NasaLibraryDataManager.shared.getSLastPageItemFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                group.leave()
            case .success(let slItemData):
                self.slItem = slItemData
                self.getDesiredPage()
                group.leave()
            }
        })
        group.wait()
        
        /// If the order is from the highest to the lowest, the last page may have only a few items, so we take the last two pages to avoid this situation and also other similar ones, otherwise the user would not be able to scroll to get more items.
        if Int(page) ?? 0 >= 2, order == .highestToLowest {
            group.enter()
            
            NasaLibraryDataManager.shared.getLibraryFilters(filters: pageUpdateFilters, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    group.leave()
                case .success(let spaceLibraryItems):
                    self.spaceLibraryItems = spaceLibraryItems
                    group.leave()
                }
            })
        } else {
            onePage = true
        }
        
        group.notify(queue: .main, execute: { [self] in
            guard !onePage else {
                NasaLibraryDataManager.shared.getLibraryFilters(filters: pageUpdateFilters, completion: { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let spaceLibraryItems):
                        self.spaceLibraryItems = spaceLibraryItems
                        self.orderSpaceItems(order: self.order)
                        completion(.success(()))
                    }
                })
                
                return
            }
            
            getSpaceLibraryItemsFiltersNewPage(filters: filters, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success():
                    completion(.success(()))
                }
            })
        })
    }
    
    public func getSpaceLibraryItemsBeginNewPage(completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        calculateNextPage()
        
        NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
                self.orderSpaceItems(order: self.order)
                completion(.success(()))
            }
        })
    }
    
    public func getSpaceLibraryItemsFiltersNewPage(filters: SpaceLibraryFilters, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        calculateNextPage()
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        NasaLibraryDataManager.shared.getLibraryFilters(filters: pageUpdateFilters, completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let spaceLibraryItems):
                self.spaceLibraryItems.collection.spaceItems.append(contentsOf: spaceLibraryItems.collection.spaceItems)
                self.orderSpaceItems(order: self.order)
                completion(.success(()))
            }
        })
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
        
        /// Check if only exists one page
        guard let stringUrl = spaceLibraryItems.collection.links?.first?.href, let url = URL(completedString: stringUrl),
              let strPage = url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage),
              let intPage = Int(strPage) else {
            return count
        }
        
        /// Calculate the items to always return a par number or all the items if is the last page
        if count % 2 == 0, intPage >= Int(page) ?? 1 {
            return count
        } else {
            return count - 1
        }
    }
    
    public func canLoadMoreData() -> Bool {
        guard let pageInt = Int(page), pageInt > 1 else { return false }
        
        if order == .highestToLowest, pageInt == 1 {
            return false
        } else {
            return true
        }
    }
    
    public func getSpaceItem(position: Int) -> SpaceItem {
        return spaceLibraryItems.collection.spaceItems[position]
    }
}
