//
//  StarViews.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/6/22.
//

import UIKit

class SmallStarView: CIView {
    private let kSize: CGFloat = 3
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = Colors.white.value
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}

class NormalWhiteStarView: CIView {
    private let kSize: CGFloat = 5
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = Colors.white.value
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}

class NormalStarView: CIView {
    private let kSize: CGFloat = 6
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = Colors.blueStar.value
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}

class BigStarView: CIView {
    private let kSize: CGFloat = 8
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = Colors.brownStar.value
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}
