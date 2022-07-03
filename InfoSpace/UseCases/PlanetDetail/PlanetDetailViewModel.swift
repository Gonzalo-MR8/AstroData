//
//  PlanetDetailViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/6/22.
//

import Foundation

final class PlanetDetailViewModel {

    private let planet: Planet!
    private let imagesBySection: Double = 3
    
    init(planet: Planet) {
        self.planet = planet
    }

    func getPlanet() -> Planet {
        return planet
    }
    
    func getNumberOfGalleryImages() -> Int {
        return planet.galleryImagesUrl.count
    }
    
    func getNumberOfSectionsOfGalleryImages() -> Int {
        guard planet.galleryImagesUrl.count >= 3 else {
            return 1
        }
        
        let imagesCount: Double = Double(planet.galleryImagesUrl.count) / imagesBySection
        
        return Int(ceil(imagesCount))
    }
    
    func getGalleryImage(position: Int) -> PlanetImage {
        return planet.galleryImagesUrl[position]
    }
    
    func getAllPlanetImages() -> ([String], [String]) {
        return (planet.galleryImagesUrl.compactMap({ $0.imageUrl }), planet.galleryImagesUrl.compactMap({ $0.title }))
    }
}
