//
//  Planeta.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import Foundation

struct Planet: Codable {
    let id: Int
    let description: String
    let headerImageUrl: String
    let satellites: Int?
    let title: String
    let galleryImagesUrl: [String]?
}

typealias Planets = [Planet]
