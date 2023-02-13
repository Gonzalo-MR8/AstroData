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

    private let services: NasaLibraryServiceable
    
    init(spaceLibraryData: SpaceLibraryData) {
        self.services = NasaLibraryServices()
        self.spaceLibraryItems = spaceLibraryData.0
        orderSpaceItems(order: order)
        self.slItem = spaceLibraryData.1
        getDesiredPage()
    }
    
    // MARK: - Network Methods
    
    /// This method manages the reset button pressed and when you want to change only the order of the space items
    public func getSpaceLibraryItemsBegin(reset: Bool = false, changeOrder: Order? = nil) async -> Result<Void, RequestError> {
        order = reset ? .highestToLowest : .lowestToHighest
        
        /// Change the order to a new order
        if let changeOrder = changeOrder {
            order = changeOrder
        }
        
        let slItemResult = await services.getSLastPageItemDefault()
        
        switch slItemResult {
        case .success(let slItemData):
            self.slItem = slItemData
            self.getDesiredPage()
        case .failure(let failure):
            return .failure(failure)
        }
        
        let libraryResult = await services.getLibraryDefault(page: page)
        
        switch libraryResult {
        case .success(let spaceLibraryItems):
            self.spaceLibraryItems = spaceLibraryItems
        case .failure(let failure):
            return .failure(failure)
        }
        
        let spaceItemsNewPage = await getSpaceLibraryItemsBeginNewPage()
        
        switch spaceItemsNewPage {
        case .success(_):
            return .success(())
        case .failure(let failure):
            self.orderSpaceItems(order: self.order)
            return .failure(failure)
        }
    }
    
    public func getSpaceLibraryItemsFilters(reset: Bool? = nil, filters: SpaceLibraryFilters) async -> Result<Void, RequestError> {
        order = filters.order
        
        if let reset = reset, reset {
            order = .highestToLowest
        }
        
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        
        /// This call gets the last page of the spaceItems, call to handle when you need to take the last or the first items depending on the order
        let slItemResult = await services.getSLastPageItemFilters(filters: filters)
        
        switch slItemResult {
        case .success(let slItemData):
            self.slItem = slItemData
            self.getDesiredPage()
        case .failure(let failure):
            return .failure(failure)
        }
        
        let libraryResult = await services.getLibraryFilters(filters: pageUpdateFilters)
        
        switch libraryResult {
        case .success(let spaceLibraryItems):
            self.spaceLibraryItems = spaceLibraryItems
        case .failure(let failure):
            return .failure(failure)
        }
        
        let spaceItemsNewPage = await getSpaceLibraryItemsFiltersNewPage(filters: filters)
        
        switch spaceItemsNewPage {
        case .success(_):
            return .success(())
        case .failure(let failure):
            self.orderSpaceItems(order: self.order)
            return .failure(failure)
        }
    }
    
    public func getSpaceLibraryItemsBeginNewPage() async -> Result<Void, RequestError> {
        calculateNextPage()
        
        let libraryResultSecondPage = await services.getLibraryDefault(page: page)
        
        switch libraryResultSecondPage {
        case .success(let spaceLibraryItems):
            self.spaceLibraryItems.collection.appendNewItemsToSpaceItems(spaceItems: spaceLibraryItems.collection.spaceItems)
            self.orderSpaceItems(order: self.order)
            return .success(())
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    public func getSpaceLibraryItemsFiltersNewPage(filters: SpaceLibraryFilters) async -> Result<Void, RequestError> {
        calculateNextPage()
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        
        let libraryResultSecondPage = await services.getLibraryFilters(filters: pageUpdateFilters)
        
        switch libraryResultSecondPage {
        case .success(let spaceLibraryItems):
            self.spaceLibraryItems.collection.appendNewItemsToSpaceItems(spaceItems: spaceLibraryItems.collection.spaceItems)
            self.orderSpaceItems(order: self.order)
            return .success(())
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    // MARK: - Private Methods

    private func getDesiredPage() {
        page = "1"
        
        if let stringUrl = slItem.collection.getPrevLink(), let url = URL(string: stringUrl),
           let page = url.getQueryStringParameter(param: ParametersConstants.kParameterPage),
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
    
    // MARK: - Public Methods
    
    public func orderSpaceItems(order: Order) {
        switch order {
        case .highestToLowest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated > $1.spaceItemsdatas.first!.dateCreated } )
        case .lowestToHighest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated < $1.spaceItemsdatas.first!.dateCreated } )
        }
    }
    
    public func getNumberOfSpaceItems() -> Int {
        let count = spaceLibraryItems.collection.spaceItems.count
        
        /// Check if only exists one page
        guard let stringUrl = spaceLibraryItems.collection.links?.first?.href, let url = URL(completedString: stringUrl),
              let strPage = url.getQueryStringParameter(param: ParametersConstants.kParameterPage),
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
