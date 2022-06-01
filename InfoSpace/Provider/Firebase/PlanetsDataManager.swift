//
//  PlanetsDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import Foundation

class PlanetsDataManager: FirebaseDataManager {
    
    private let kPlanetsPath = "Planetas.json"
    static var shared = PlanetsDataManager()
    
    func getPlanets(completion: @escaping (Result<Planets, WebServiceError>) -> ()) {
        var wsGetPlanets = createWSPlanets()

        wsGetPlanets.completion = { result in
            switch result {
            case .failure (let error):
                print("Error getting planets: \(error.localizedDescription)")
                
                completion(.failure(.generic(error: error)))
            case .success (let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    
                    return
                }
                
                do {
                    let planets = try JSONDecoder().decode(Planets.self, from: data)
                    
                    completion(.success(planets))
                } catch let error {
                    print("Error decoding: \(error)")
                    
                    completion(.failure(.decondingError))
                }
            }
        }
        
        NetworkManager.shared.call(ws: wsGetPlanets)
    }
    
    //MARK: - WSPlanets
    
    func createWSPlanets() -> WebService {
        let wsPlanets = createWS(path: kPlanetsPath)
        
        return wsPlanets
    }
}
