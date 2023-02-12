//
//  ApodService.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol ApodServiceable {
    func getApod(date: Date?) async -> Result<APOD, RequestError>
}

struct ApodService: NetworkClient, ApodServiceable {
    func getApod(date: Date?) async -> Result<APOD, RequestError> {
        return await sendRequest(endPoint: ApodEndPoint.getApod(date: date), responseModel: APOD.self)
    }
}
