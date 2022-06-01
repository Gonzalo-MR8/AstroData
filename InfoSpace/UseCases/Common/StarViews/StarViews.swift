//
//  StarViews.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/6/22.
//

import UIKit

class SmallStarView: View {
    private let kSize: CGFloat = 3
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = UIColor.white
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}

class NormalStarView: View {
    private let kSize: CGFloat = 6
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = UIColor.blue
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}

class BigStarView: View {
    private let kSize: CGFloat = 10
    
    func setup() {
        self.roundedBorders = true
        self.backgroundColor = UIColor.brown
        
        self.widthAnchor.constraint(equalToConstant: kSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: kSize).isActive = true
    }
}
