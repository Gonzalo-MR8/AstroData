//
//  FontTypes.swift
//  InfoSpace
//
//  Created by GonzaloMR on 4/11/22.
//

import UIKit

struct FontData {
    let name: String
    let size: CGFloat?
    
    init(name: String) {
        self.name = name
        self.size = nil
    }
    
    init(name: String, size: CGFloat?) {
        self.name = name
        self.size = size
    }
}

struct FontNames {
    // Space Ranger
    static let kSpaceRanger             = "spaceranger"
    static let kSpaceRanger3d           = "spaceranger3d"
    static let kSpaceRanger3dItal       = "spaceranger3dital"
    static let kSpaceRangerAcad         = "spacerangeracad"
    static let kSpaceRangerAcadItal     = "spacerangeracadital"
    static let kSpaceRangerBold         = "spacerangerbold"
    static let kSpaceRangerBoldItal     = "spacerangerboldital"
    static let kSpaceRangerChrome       = "spacerangerchrome"
    static let kSpaceRangerChromeItal   = "spacerangerchromeital"
    static let kSpaceRangerCond         = "spacerangercondensed"
    static let kSpaceRangerCondItal     = "spacerangercondital"
    static let kSpaceRangerExpand       = "spacerangerexpand"
    static let kSpaceRangerExpandItal   = "spacerangerexpandital"
    static let kSpaceRangerHalf         = "spacerangerhalf"
    static let kSpaceRangerHalfItal     = "spacerangerhalfital"
    static let kSpaceRangerItal         = "spacerangerital"
    static let kSpaceRangerLaser        = "spacerangerlaser"
    static let kSpaceRangerOut          = "spacerangerout"
    static let kSpaceRangerSemital      = "spacerangersemital"
    
    // NotoSansJP
    static let kNotoSansJPBlack         = "NotoSansJP-Black"
    static let kNotoSansJPBold          = "NotoSansJP-Bold"
    static let kNotoSansJPLight         = "NotoSansJP-Light"
    static let kNotoSansJPMedium        = "NotoSansJP-Medium"
    static let kNotoSansJPRegular       = "NotoSansJP-Regular"
    static let kNotoSansJPThin          = "NotoSansJP-Thin"
}
