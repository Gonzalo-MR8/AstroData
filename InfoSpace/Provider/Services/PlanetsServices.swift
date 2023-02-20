//
//  PlanetsServices.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol PlanetsServiceable {
    func getPlanets() async -> Result<Planets, RequestError>
}

struct PlanetsServices: NetworkClient, PlanetsServiceable {
    func getPlanets() async -> Result<Planets, RequestError> {
        return await sendRequest(endPoint: PlanetsEndPoint.getPlanets, responseModel: Planets.self)
    }
}
