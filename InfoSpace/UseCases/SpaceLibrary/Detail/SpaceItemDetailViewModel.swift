//
//  SpaceItemDetailViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import Foundation

final class SpaceItemDetailViewModel {
    
    private var spaceItem: SpaceItem!
    
    init(spaceItem: SpaceItem) {
        self.spaceItem = spaceItem
    }
    
    public func getSpaceItemData() -> SpaceItemData {
        return spaceItem.spaceItemdata
    }
    
    public func getSpaceItemLinks() -> [ItemLink] {
        return spaceItem.links
    }
}
