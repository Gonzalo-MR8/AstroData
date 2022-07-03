//
//  APODDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import Foundation

class APODDataManager: NasaDataManager {
    
    private let kAPODPath = "planetary/apod"
    
    private let kParameterDate = "date"
    
    static var shared = APODDataManager()
    
    func getAPOD(date: Date?, completion: @escaping (Result<APOD, WebServiceError>) -> ()) {
        var wsAPOD = createWSAPOD(date: date)

        wsAPOD.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting APOD: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let apod = try JSONDecoder().decode(APOD.self, from: data)
                    
                    completion(.success(apod))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: wsAPOD)
    }
    
    //MARK: - WSAPOD
    
    func createWSAPOD(date: Date?) -> WebService {
        var wsAPOD = createWS(path: kAPODPath)
        
        if let date = date {
            let formatter = DateFormatter.dateFormatterLocale
            formatter.dateFormat = Constants.kShortDateFormat
            
            wsAPOD.urlParameters?[kParameterDate] = formatter.string(from: date)
        }
        
        return wsAPOD
    }
}
