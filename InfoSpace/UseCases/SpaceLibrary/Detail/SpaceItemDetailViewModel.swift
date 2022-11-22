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
    
    public func getSpaceItem() -> SpaceItem {
        return spaceItem
    }
}
