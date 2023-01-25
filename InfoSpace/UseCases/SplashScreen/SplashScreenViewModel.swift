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
        
        /// The onePage variable is used when the call has only 1 page to initialize the spaceLibraryItems variable and not add new items in the second call as if it came from more than one page.
        var onePage = false
        
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
        
        /// If the order is from the highest to the lowest, the last page may have only a few items, so we take the last two pages to avoid this situation and also other similar ones, otherwise the user would not be able to scroll to get more items.
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
        } else {
            onePage = true
            group.leave()
        }
        
        group.notify(queue: .main, execute: {
            NasaLibraryDataManager.shared.getLibraryDefault(page: page, completion: { result in
                switch result {
                case .failure(let error):
                    print("Space library WS error: \(error)")
                    completion(.failure(error))
                case .success(let spaceLibraryItemsData):
                    if onePage {
                        spaceLibraryItems = spaceLibraryItemsData
                    } else {
                        spaceLibraryItems?.collection.spaceItems.append(contentsOf: spaceLibraryItemsData.collection.spaceItems)
                    }
                    completion(.success((spaceLibraryItems!, slItem)))
                }
            })
        })
    }
}
