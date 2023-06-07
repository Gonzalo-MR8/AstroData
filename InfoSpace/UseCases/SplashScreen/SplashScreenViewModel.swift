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
        let nasaLibraryResult = await getSpaceLibraryItems()
        
        switch apodResult {
        case .success(let apodData):
            apod = apodData
        case .failure(let failure):
            /// This init is to avoid blocking the rest of the app when apod is unavailable, and to be able to continue using app.
            apod = APOD()
            requestError = failure
        }
        
        switch planetsResult {
        case .success(let planetsData):
            planets = planetsData
        case .failure(let failure):
            requestError = failure
        }
        
        switch nasaLibraryResult {
        case .success(let spaceLibraryData):
            self.spaceLibraryData = spaceLibraryData
        case .failure(let failure):
            requestError = failure
            return .failure(requestError ?? .noData)
        }
        
        guard let planets = planets, let apod = apod, let spaceLibraryData = spaceLibraryData else {
            return .failure(requestError ?? .noData)
        }
        
        return .success((planets, apod, spaceLibraryData))
    }
    
    private func getSpaceLibraryItems() async -> Result<SpaceLibraryData, RequestError> {
        let nasaLibraryServices: NasaLibraryServiceable = NasaLibraryServices()
        
        var slItem: SLastPageItem!
        var spaceLibraryData: SpaceLibraryData!
        
        let slItemResult = await nasaLibraryServices.getSLastPageItemDefault()
        
        switch slItemResult {
        case .success(let slItemData):
            slItem = slItemData
        case .failure(let failure):
            requestError = failure
        }
        
        guard var page = slItem?.getPage() else {
            requestError = .noData
            return .failure(.noData)
        }
        
        let libraryResult = await nasaLibraryServices.getLibraryDefault(page: page)
        
        switch libraryResult {
        case .success(let libraryData):
            spaceLibraryData = (libraryData, slItem)
        case .failure(let failure):
            return .failure(failure)
        }
        
        /// We subtract a page to get the next page in the service
        if let numberPage = Int(page) {
            page = String(numberPage - 1)
        }
        
        let libraryResultSecondPage = await nasaLibraryServices.getLibraryDefault(page: page)
        
        switch libraryResultSecondPage {
        case .success(let libraryData):
            spaceLibraryData?.0.collection.appendNewItemsToSpaceItems(spaceItems: libraryData.collection.spaceItems)
            return .success(spaceLibraryData)
        case .failure:
            /// No failure is returned here because this point is only reached when the second page does not exist.
            return .success((spaceLibraryData))
        }
    }
}
