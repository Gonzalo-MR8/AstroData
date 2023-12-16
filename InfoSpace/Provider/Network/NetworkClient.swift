//
//  NetworkClient.swift
//  InfoSpace
//
//  Created by GonzaloMR on 11/2/23.
//

import Foundation

protocol NetworkClient {
    func sendRequest<T: Decodable>(endPoint: EndPoint, responseModel: T.Type) async throws -> T
}

extension NetworkClient {
    func sendRequest<T>(endPoint: EndPoint, responseModel: T.Type) async throws -> T where T: Decodable {
        let kRequestTimeout: TimeInterval = 20

        guard NetworkManager.shared.isConnected else {
            throw RequestError.noInternetConnection
        }

        guard let request = createRequest(from: endPoint) else {
            throw RequestError.invalidURL
        }
        
        do {
            URLSession.shared.configuration.timeoutIntervalForRequest = kRequestTimeout
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
              throw RequestError.noHttpResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                  throw RequestError.parseError
                }
                
                return decodedResponse
            case 401:
              throw RequestError.unauthorized
            default:
              throw RequestError.statusError(code: httpResponse.statusCode)
            }
        } catch {
          throw RequestError.unknown
        }
    }
    
    // MARK: - Private methods
    
    private func createRequest(from endPoint: EndPoint) -> URLRequest? {
        // Url
        guard let url = composeUrl(url: endPoint.basePath + endPoint.path, params: endPoint.urlParameters) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        // Method
        request.httpMethod = endPoint.method.rawValue
        
        // Body
        if let body = endPoint.postBody {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        // Custom headers
        if let customHeaders = endPoint.customHeaders {
            for (header, value) in customHeaders {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        return request
    }
    
    private func composeUrl(url: String, params: [String: String]?) -> URL? {
        guard let params = params else { return URL(completedString: url) }
        
        guard let url = URL(completedString: url) else { return nil }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        
        let queryItems = params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
}
