//
//  APODViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import Foundation

final class APODViewModel {
    
    private var apod: APOD
    private let services: ApodServiceable
    
    init(apod: APOD) {
        self.apod = apod
        self.services = ApodServices()
    }
    
    func getApod() -> APOD {
        return apod
    }
    
    func getNewAPOD(date: Date) async throws {
      apod = try await services.getApod(date: date)
    }
}
