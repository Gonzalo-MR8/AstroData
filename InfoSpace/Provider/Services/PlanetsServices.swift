//
//  PlanetsServices.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol PlanetsServiceable {
    func getPlanets() async throws -> Planets
}

struct PlanetsServices: NetworkClient, PlanetsServiceable {
  func getPlanets() async throws -> Planets {
    return try await sendRequest(endPoint: PlanetsEndPoint.getPlanets, responseModel: Planets.self)
  }
}
