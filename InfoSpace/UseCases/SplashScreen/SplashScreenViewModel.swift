//
//  SplashScreenViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 29/5/22.
//

import Foundation

final class SplashScreenViewModel {
  var planets: Planets?
  var apod: APOD?
  var spaceLibraryData: SpaceLibraryData?

  func getInitialData() async throws -> DashboardData {

    let apodServices: ApodServiceable = ApodServices()
    let planetsServices: PlanetsServiceable = PlanetsServices()

    do {
      apod = try await apodServices.getApod(date: nil)
    } catch {
      /// This init is to avoid blocking the rest of the app when apod is unavailable, and to be able to continue using app.
      apod = APOD()
    }

    planets = try await planetsServices.getPlanets()
    spaceLibraryData = try await getSpaceLibraryItems()

    guard let planets = planets, let apod = apod, let spaceLibraryData = spaceLibraryData else {
      throw RequestError.noData
    }

    return (planets, apod, spaceLibraryData)
  }

  private func getSpaceLibraryItems() async throws -> SpaceLibraryData {
    let nasaLibraryServices: NasaLibraryServiceable = NasaLibraryServices()

    var slItem: SLastPageItem!
    var spaceLibraryData: SpaceLibraryData!

    slItem = try await nasaLibraryServices.getSLastPageItemDefault()

    guard var page = slItem?.getPage() else {
      throw RequestError.noData
    }

    let libraryData = try await nasaLibraryServices.getLibraryDefault(page: page)

    spaceLibraryData = (libraryData, slItem)

    /// We subtract a page to get the next page in the service
    if let numberPage = Int(page) {
      page = String(numberPage - 1)
    }

    do {
      let libraryData = try await nasaLibraryServices.getLibraryDefault(page: page)
      spaceLibraryData?.0.collection.appendNewItemsToSpaceItems(spaceItems: libraryData.collection.spaceItems)
      return spaceLibraryData
    } catch {
      /// No failure is returned here because this point is only reached when the second page does not exist.
      return spaceLibraryData
    }
  }
}
