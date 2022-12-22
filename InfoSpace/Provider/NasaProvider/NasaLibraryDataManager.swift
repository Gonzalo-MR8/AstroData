//
//  NasaLibraryDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/10/22.
//

import Foundation

class NasaLibraryDataManager {
    
    private let baseUrl: String = Bundle.string(for: InfoConstants.kNasaLibraryBaseUrl)!
    
    private let kParameterSearchText = "q"
    private let kParameterYearStart = "year_start"
    private let kParameterYearEnd = "year_end"
    private let kParameterMediaType = "media_type"
    public  let kParameterPage = "page"
        
    private let kLastPageNumber: String = "100"
    private let kParameterValueYearStart = Calendar.current.component(.year, from: Date())
    
    static var shared = NasaLibraryDataManager()
    
    func getLibraryDefault(page: String, completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
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
    
    func getSLastPageItemDefault(completion: @escaping (Result<SLastPageItem, WebServiceError>) -> ()) {
        var getLibraryDefault = createWSLibraryDefault(page: kLastPageNumber)

        getLibraryDefault.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting SLastPageItemDefault: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let slItem = try JSONDecoder().decode(SLastPageItem.self, from: data)
                    
                    completion(.success(slItem))
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
    
    func getSLastPageItemFilters(filters: SpaceLibraryFilters, completion: @escaping (Result<SLastPageItem, WebServiceError>) -> ()) {
        var pageUpdateFilters = filters
        pageUpdateFilters.page = kLastPageNumber
        var getLibraryDefault = createWSLibraryFilters(filters: pageUpdateFilters)

        getLibraryDefault.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting SLastPageItemFilters: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let slItem = try JSONDecoder().decode(SLastPageItem.self, from: data)
                    
                    completion(.success(slItem))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: getLibraryDefault)
    }
    
    func getMediaURLs(jsonUrl: String, completion: @escaping (Result<[String], WebServiceError>) -> ()) {
        var webServiceMediaURLs = WebService(url: jsonUrl)

        webServiceMediaURLs.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting MediaURLs: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let strings = try JSONDecoder().decode([String].self, from: data)
                    
                    completion(.success(strings))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: webServiceMediaURLs)
    }
    
    //MARK: - WSNasaLibrary
    
    func createWSLibraryDefault(page: String) -> WebService {
        var parameters = [String:String]()
        
        parameters[kParameterYearStart] = kParameterValueYearStart.description
        parameters[kParameterPage] = page
        
        let webService = WebService(url: baseUrl, urlParameters: parameters)

        return webService
    }
    
    func createWSLibraryFilters(filters: SpaceLibraryFilters) -> WebService {
        var parameters = [String:String]()
        
        parameters[kParameterPage] = String(filters.page)
        
        if let searchText = filters.searchText {
            parameters[kParameterSearchText] = searchText
        }
        
        if let yearEnd = filters.yearEnd {
            parameters[kParameterYearEnd] = yearEnd
        } else {
            parameters[kParameterYearStart] = kParameterValueYearStart.description
        }
        
        if let yearStart = filters.yearStart {
            parameters[kParameterYearStart] = yearStart
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
