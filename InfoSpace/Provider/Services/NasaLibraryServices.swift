//
//  NasaLibraryServices.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol NasaLibraryServiceable {
    func getLibraryDefault(page: String) async throws -> SpaceLibraryItems
    func getLibraryFilters(filters: SpaceLibraryFilters) async throws -> SpaceLibraryItems
    func getSLastPageItemDefault() async throws -> SLastPageItem
    func getSLastPageItemFilters(filters: SpaceLibraryFilters) async throws -> SLastPageItem
    func getMediaURLs(jsonUrl: String) async throws -> [String]
}

struct NasaLibraryServices: NetworkClient, NasaLibraryServiceable {
  func getLibraryDefault(page: String) async throws -> SpaceLibraryItems {
    return try await sendRequest(endPoint: NasaLibraryEndPoint.getLibraryDefault(page: page), responseModel: SpaceLibraryItems.self)
  }
  
  func getLibraryFilters(filters: SpaceLibraryFilters) async throws -> SpaceLibraryItems {
    return try await sendRequest(endPoint: NasaLibraryEndPoint.getLibraryFilters(filters: filters), responseModel: SpaceLibraryItems.self)
  }
  
  func getSLastPageItemDefault() async throws -> SLastPageItem {
    return try await sendRequest(endPoint: NasaLibraryEndPoint.getSLastPageItemDefault, responseModel: SLastPageItem.self)
  }
  
  func getSLastPageItemFilters(filters: SpaceLibraryFilters) async throws -> SLastPageItem {
    var updatePageFilters = filters
    updatePageFilters.page = ParametersConstants.kLastPageNumber
    return try await sendRequest(endPoint: NasaLibraryEndPoint.getSLastPageItemFilters(filters: updatePageFilters), responseModel: SLastPageItem.self)
  }
  
  func getMediaURLs(jsonUrl: String) async throws -> [String] {
    return try await sendRequest(endPoint: NasaLibraryEndPoint.getMediaURLs(jsonUrl: jsonUrl), responseModel: [String].self)
  }
}
