//
//  DashboardViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import Foundation

final class DashboardViewModel {
    
    private var planets: Planets = []
    private let dashboardItems: DashboardItems = [DashboardItem(title: "Mars rover images", assetImageName: "marsRover"), DashboardItem(title: "Astronomy picture of the day", assetImageName: "camera"), DashboardItem(title: "Asteroids near the Earth", assetImageName: "asteroid"), DashboardItem(title: "Space library", assetImageName: "library")]
    
    // MARK: - Planets methods
    
    init(planets: Planets) {
        self.planets = planets
        sortPlanets()
    }
    
    func sortPlanets() {
        planets.sort(by: { $0.id < $1.id })
    }
    
    func numberOfPlanets() -> Int {
        return planets.count
    }
    
    func getPlanet(position: Int) -> Planet {
        return planets[position]
    }
    
    // MARK: - DashboardItems methods
    
    func numberOfDashboardItems() -> Int {
        return dashboardItems.count
    }
    
    func getDashboardItem(position: Int) -> DashboardItem {
        return dashboardItems[position]
    }
}
