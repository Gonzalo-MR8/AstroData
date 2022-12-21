//
//  ImagesGalleryViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/6/22.
//

import Foundation

final class ImagesGalleryViewModel {

    private let imagesUrl: [String]!
    private let highDefinitionUrlImages: [String]!
    private let titles: [String]?
    
    init(imagesUrl: [String], highDefinitionUrlImages: [String], titles: [String]?) {
        self.imagesUrl = imagesUrl
        self.titles = titles
        self.highDefinitionUrlImages = highDefinitionUrlImages
    }
    
    func getNumberOfImages() -> Int {
        return imagesUrl.count
    }
    
    func getImage(position: Int) -> String {
        return imagesUrl[position]
    }
    
    func getHighDefinitionUrlImage(position: Int) -> String {
        return highDefinitionUrlImages[position]
    }
    
    func getTitle(position: Int) -> String? {
        return titles?[position]
    }
}
