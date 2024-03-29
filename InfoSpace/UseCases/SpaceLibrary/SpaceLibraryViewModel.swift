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
    
    private let services: NasaLibraryServiceable
    
    private var spaceLibraryItems: SpaceLibraryItems!
    private var slItem: SLastPageItem!
    private var order: Order = .highestToLowest
    private var page: String = "1"
    
    init(spaceLibraryData: SpaceLibraryData) {
        self.services = NasaLibraryServices()
        self.spaceLibraryItems = spaceLibraryData.0
        orderSpaceItems(order: order)
        self.slItem = spaceLibraryData.1
        getDesiredPage()
    }
    
    // MARK: - Network Methods
    
    public func getSpaceLibraryItemsFilters(reset: Bool? = nil, filters: SpaceLibraryFilters) async throws {
        order = filters.order
        
        if let reset = reset, reset {
            spaceLibraryItems = nil
            order = .highestToLowest
        }
        
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        
        /// This call gets the last page of the spaceItems, call to handle when you need to take the last or the first items depending on the order
        slItem = try await services.getSLastPageItemFilters(filters: filters)
        getDesiredPage()

        spaceLibraryItems = nil
        spaceLibraryItems = try await services.getLibraryFilters(filters: pageUpdateFilters)

        do {
          try await getSpaceLibraryItemsFiltersNewPage(filters: filters)
        } catch {
          /// No failure is returned here because this point is only reached when the second page does not exist.
          orderSpaceItems(order: order)
        }
    }
    
    public func getSpaceLibraryItemsFiltersNewPage(filters: SpaceLibraryFilters) async throws {
        calculateNextPage()
        var pageUpdateFilters = filters
        pageUpdateFilters.page = page
        
        let spaceLibraryData = try await services.getLibraryFilters(filters: pageUpdateFilters)

        spaceLibraryItems.collection.appendNewItemsToSpaceItems(spaceItems: spaceLibraryData.collection.spaceItems)
        orderSpaceItems(order: order)
    }
    
    // MARK: - Private Methods

    private func getDesiredPage() {
        page = ParametersConstants.kLastPageNumber
        
        if let page = slItem.getPage(),
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
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated > $1.spaceItemsdatas.first!.dateCreated })
        case .lowestToHighest:
            spaceLibraryItems.collection.spaceItems = spaceLibraryItems.collection.spaceItems.sorted(by: { $0.spaceItemsdatas.first!.dateCreated < $1.spaceItemsdatas.first!.dateCreated })
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
