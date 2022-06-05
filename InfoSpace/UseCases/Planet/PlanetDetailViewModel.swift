//
//  PlanetDetailViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/6/22.
//

import Foundation

final class PlanetDetailViewModel {

    private let planet: Planet!
    
    init(planet: Planet) {
        self.planet = planet
    }

    func getPlanet() -> Planet {
        return planet
    }
}
