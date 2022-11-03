//
//  NasaLibraryDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/10/22.
//

import Foundation

class NasaLibraryDataManager {
    
    let baseUrl: String = Bundle.string(for: InfoConstants.kNasaLibraryBaseUrl)!
    
    private let kParameterSearchText = "q"
    private let kParameterYearStart = "year_start"
    private let kParameterYearEnd = "year_end"
    private let kParameterMediaType = "media_type"
    private let kParameterPage = "page"
        
    private let kParameterValueYearStart = Calendar.current.component(.year, from: Date())
    
    static var shared = NasaLibraryDataManager()
    
    func getLibraryDefault(page: Int, completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
        var getLibraryDefault = createWSLibraryDefault(page: page)

        getLibraryDefault.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting SpaceLibraryItems: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let libraryItems = try JSONDecoder().decode(SpaceLibraryItems.self, from: data)
                    
                    completion(.success(libraryItems))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: getLibraryDefault)
    }
    
    func getLibraryFilters(filters: SpaceLibraryFilters, completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
        var getLibraryFilters = createWSLibraryFilters(filters: filters)

        getLibraryFilters.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting SpaceLibraryItems: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let libraryItems = try JSONDecoder().decode(SpaceLibraryItems.self, from: data)
                    
                    completion(.success(libraryItems))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: getLibraryFilters)
    }
    
    //MARK: - WSNasaLibrary
    
    func createWSLibraryDefault(page: Int) -> WebService {
        var parameters = [String:String]()
        
        parameters[kParameterYearStart] = kParameterValueYearStart.description
        parameters[kParameterPage] = String(page)
        
        let webService = WebService(url: baseUrl, urlParameters: parameters)

        return webService
    }
    
    func createWSLibraryFilters(filters: SpaceLibraryFilters) -> WebService {
        var parameters = [String:String]()
        
        parameters[kParameterPage] = String(filters.page)
        
        if let searchText = filters.searchText {
            parameters[kParameterSearchText] = searchText
        }
        
        if let yearStart = filters.yearStart {
            parameters[kParameterYearStart] = yearStart
        }
        
        if let yearEnd = filters.yearEnd {
            parameters[kParameterYearEnd] = yearEnd
        }
        
        if let mediaTypes = filters.mediaTypes {
            var mediaTypesString: String?
            
            mediaTypes.forEach { type in
                if mediaTypesString == nil {
                    mediaTypesString = type.rawValue
                } else {
                    mediaTypesString = mediaTypesString! + ",\(type.rawValue)"
                }
            }
            
            if let mediaTypesString = mediaTypesString {
                parameters[kParameterMediaType] = mediaTypesString
            }
        }
        
        let webService = WebService(url: baseUrl, urlParameters: parameters)

        return webService
    }
}
