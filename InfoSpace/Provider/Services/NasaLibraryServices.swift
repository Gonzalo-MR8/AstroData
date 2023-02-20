//
//  NasaLibraryServices.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

/// It conforms to the Serviceable protocol, which is critical for testing and dependency injection.
protocol NasaLibraryServiceable {
    func getLibraryDefault(page: String) async -> Result<SpaceLibraryItems, RequestError>
    func getLibraryFilters(filters: SpaceLibraryFilters) async -> Result<SpaceLibraryItems, RequestError>
    func getSLastPageItemDefault() async -> Result<SLastPageItem, RequestError>
    func getSLastPageItemFilters(filters: SpaceLibraryFilters) async -> Result<SLastPageItem, RequestError>
    func getMediaURLs(jsonUrl: String) async -> Result<[String], RequestError>
}

struct NasaLibraryServices: NetworkClient, NasaLibraryServiceable {
    func getLibraryDefault(page: String) async -> Result<SpaceLibraryItems, RequestError> {
        return await sendRequest(endPoint: NasaLibraryEndPoint.getLibraryDefault(page: page), responseModel: SpaceLibraryItems.self)
    }
    
    func getLibraryFilters(filters: SpaceLibraryFilters) async -> Result<SpaceLibraryItems, RequestError> {
        return await sendRequest(endPoint: NasaLibraryEndPoint.getLibraryFilters(filters: filters), responseModel: SpaceLibraryItems.self)
    }
    
    func getSLastPageItemDefault() async -> Result<SLastPageItem, RequestError> {
        return await sendRequest(endPoint: NasaLibraryEndPoint.getSLastPageItemDefault, responseModel: SLastPageItem.self)
    }
    
    func getSLastPageItemFilters(filters: SpaceLibraryFilters) async -> Result<SLastPageItem, RequestError> {
        var updatePageFilters = filters
        updatePageFilters.page = ParametersConstants.kLastPageNumber
        return await sendRequest(endPoint: NasaLibraryEndPoint.getSLastPageItemFilters(filters: updatePageFilters), responseModel: SLastPageItem.self)
    }
    
    func getMediaURLs(jsonUrl: String) async -> Result<[String], RequestError> {
        return await sendRequest(endPoint: NasaLibraryEndPoint.getMediaURLs(jsonUrl: jsonUrl), responseModel: [String].self)
    }
}
