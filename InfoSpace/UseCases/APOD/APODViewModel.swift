//
//  APODViewModel.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import Foundation

final class APODViewModel {
    
    private var apod: APOD!
    
    init(apod: APOD) {
        self.apod = apod
    }
    
    func getApod() -> APOD {
        return apod
    }
    
    func getNewAPOD(date: Date, completion: @escaping (Result<Void, WebServiceError>) -> ()) {
        APODDataManager.shared.getAPOD(date: date, completion: { result in
            switch result {
            case .failure(let error):
                print("Apod WS error: \(error)")
                completion(.failure(error))
            case .success(let apod):
                self.apod = apod
                completion(.success(()))
            }
        })
    }
}
