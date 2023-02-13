//
//  SplashScreenViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 29/5/22.
//

import Foundation

final class SplashScreenViewModel {
    var requestError: RequestError?
    var planets: Planets?
    var apod: APOD?
    var spaceLibraryData: SpaceLibraryData?
    
    func getInitialData() async -> Result<DashboardData, RequestError> {
        
        let apodServices: ApodServiceable = ApodServices()
        let planetsServices: PlanetsServiceable = PlanetsServices()
        
        let apodResult = await apodServices.getApod(date: nil)
        let planetsResult = await planetsServices.getPlanets()
        
        switch apodResult {
        case .success(let apodData):
            apod = apodData
        case .failure(let failure):
            requestError = failure
        }
        
        switch planetsResult {
        case .success(let planetsData):
            planets = planetsData
        case .failure(let failure):
            requestError = failure
        }
        
        await getSpaceLibraryItems()
        
        guard let planets = planets, let apod = apod, let spaceLibraryData = spaceLibraryData else {
            print(requestError ?? .noData)
            return .failure(requestError ?? .noData)
        }
        
        return .success((planets, apod, spaceLibraryData))
    }
    
    
    private func getSpaceLibraryItems() async {
        var slItem: SLastPageItem?
        
        let nasaLibraryServices: NasaLibraryServiceable = NasaLibraryServices()
        
        let slItemResult = await nasaLibraryServices.getSLastPageItemDefault()
        
        switch slItemResult {
        case .success(let slItemData):
            slItem = slItemData
        case .failure(let failure):
            requestError = failure
        }
        
        guard let slItem = slItem, let strUrl = slItem.collection.getPrevLink(), let url = URL(string: strUrl), var page = url.getQueryStringParameter(param: ParametersConstants.kParameterPage) else {
            requestError = .noData
            return
        }
        
        let libraryResult = await nasaLibraryServices.getLibraryDefault(page: page)
        
        switch libraryResult {
        case .success(let libraryData):
            spaceLibraryData = (libraryData, slItem)
        case .failure(let failure):
            requestError = failure
        }
        
        /// We subtract a page to get the next page in the service
        if let numberPage = Int(page) {
            page = String(numberPage - 1)
        }
        
        let libraryResultSecondPage = await nasaLibraryServices.getLibraryDefault(page: page)
        
        switch libraryResultSecondPage {
        case .success(let libraryData):
            spaceLibraryData?.0.collection.appendNewItemsToSpaceItems(spaceItems: libraryData.collection.spaceItems)
        case .failure(_):
            break
        }
    }
}
