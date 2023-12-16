//
//  ApodServices.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol ApodServiceable {
    func getApod(date: Date?) async throws -> APOD
}

struct ApodServices: NetworkClient, ApodServiceable {
  func getApod(date: Date?) async throws -> APOD {
    return try await sendRequest(endPoint: ApodEndPoint.getApod(date: date), responseModel: APOD.self)
  }
}
