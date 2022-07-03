//
//  SplashScreenViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 29/5/22.
//

import Foundation

final class SplashScreenViewModel {
    
    func getInitialData(completion: @escaping (Result<DashboardData, WebServiceError>) -> ()) {
        let group = DispatchGroup()
        
        var wsError: WebServiceError?
        var planets: Planets?
        var apod: APOD?
        
        group.enter()
        getAPOD(completion: { result in
            switch result {
            case .failure(let error):
                wsError = error
                group.leave()
            case .success(let apodData):
                apod = apodData
                group.leave()
            }
        })
        
        group.enter()
        getPlanets(completion: { result in
            switch result {
            case .failure(let error):
                wsError = error
                group.leave()
            case .success(let planetsData):
                planets = planetsData
                group.leave()
            }
        })
        
        group.notify(queue: .main, execute: {
            guard let planets = planets, let apod = apod else {
                completion(.failure(wsError ?? WebServiceError.unknown))
                return
            }

            completion(.success((planets, apod)))
        })
    }
    
    private func getAPOD(completion: @escaping (Result<APOD, WebServiceError>) -> ()) {
        APODDataManager.shared.getAPOD(date: nil, completion: { result in
            switch result {
            case .failure(let error):
                print("Apod WS error: \(error)")
                completion(.failure(error))
            case .success(let apod):
                completion(.success(apod))
            }
        })
    }

    private func getPlanets(completion: @escaping (Result<Planets, WebServiceError>) -> ()) {
        PlanetsDataManager.shared.getPlanets(completion: { result in
            switch result {
            case .failure(let error):
                print("Planets WS error: \(error)")
                completion(.failure(error))
            case .success(let planets):
                completion(.success(planets))
            }
        })
    }
    
}
