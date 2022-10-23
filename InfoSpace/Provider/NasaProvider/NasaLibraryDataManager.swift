//
//  NasaLibraryDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/10/22.
//

import Foundation

class NasaLibraryDataManager {
    
    let baseUrl: String = Bundle.string(for: InfoConstants.kNasaLibraryBaseUrl)!
    
    private let kParameterYearStart = "year_start"
        
    private let kParameterValueYearStart = Calendar.current.component(.year, from: Date())
    
    static var shared = NasaLibraryDataManager()
    
    func getLibraryBegin(completion: @escaping (Result<SpaceLibraryItems, WebServiceError>) -> ()) {
        var wsWSLibraryBegin = createWSLibraryBegin()

        wsWSLibraryBegin.completion = { result in
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
        
        NetworkManager.shared.call(ws: wsWSLibraryBegin)
    }
    
    //MARK: - WSNasaLibrary
    
    func createWSLibraryBegin() -> WebService {
        var parameters = [String:String]()
        
        parameters[kParameterYearStart] = kParameterValueYearStart.description

        let webService = WebService(url: baseUrl, urlParameters: parameters)

        return webService
    }
}
