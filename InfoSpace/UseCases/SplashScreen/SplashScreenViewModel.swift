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
        var spaceLibraryData: SpaceLibraryData?
        
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
        
        group.enter()
        getSpaceLibraryItems(completion: { result in
            switch result {
            case .failure(let error):
                wsError = error
                group.leave()
            case .success(let spaceLibraryItemsData):
                spaceLibraryData = spaceLibraryItemsData
                group.leave()
            }
        })
        
        group.notify(queue: .main, execute: {
            guard let planets = planets, let apod = apod, let spaceLibraryData = spaceLibraryData else {
                completion(.failure(wsError ?? WebServiceError.unknown))
                return
            }
            
            completion(.success((planets, apod, spaceLibraryData)))
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
    
    private func getSpaceLibraryItems(completion: @escaping (Result<SpaceLibraryData, WebServiceError>) -> ()) {
        let group = DispatchGroup()
        
        var wsError: WebServiceError?
        var slItem: SLastPageItem?
        var spaceLibraryItems: SpaceLibraryItems?
        
        group.enter()
        NasaLibraryDataManager.shared.getSLastPageItemDefault(completion: { result in
            switch result {
            case .failure(let error):
                print("getLastPage WS error: \(error)")
                wsError = error
                group.leave()
            case .success(let slItemData):
                slItem = slItemData
                group.leave()
            }
        })
        group.wait()
        
        group.enter()
        guard let slItem = slItem, let strUrl = slItem.collection.getPrevLink(), let url = URL(string: strUrl), let page = url.getQueryStringParameter(param: NasaLibraryDataManager.shared.kParameterPage) else {
            completion(.failure(wsError ?? WebServiceError.unknown))
            return
        }
        
        // We do this and take another page to prevent if the last page have only a few items
        if Int(page) ?? 0 >= 2 {
            NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
                switch result {
                case .failure(let error):
                    print("Space library WS error: \(error)")
                    group.leave()
                case .success(let spaceLibraryItemsData):
                    spaceLibraryItems = spaceLibraryItemsData
                    group.leave()
                }
            })
        }
        
        group.notify(queue: .main, execute: {
            NasaLibraryDataManager.shared.getLibraryDefault(page: String(Int(page)! - 1), completion: { result in
                switch result {
                case .failure(let error):
                    print("Space library WS error: \(error)")
                    completion(.failure(error))
                case .success(let spaceLibraryItemsData):
                    spaceLibraryItems?.collection.spaceItems.append(contentsOf: spaceLibraryItemsData.collection.spaceItems)
                    completion(.success((spaceLibraryItems!, slItem)))
                }
            })
        })
    }
}
