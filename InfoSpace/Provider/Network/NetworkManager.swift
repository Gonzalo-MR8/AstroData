//
//  NetworkManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/5/22.
//

import Foundation

enum CreateRequestError: Error {
    case composingUrl
    case generic(error: Error?)
}

class NetworkManager {
    
    private let kRequestTimeout: TimeInterval = 20
    
    private let reachability = Reachability()
    private var reachabilityStarted = false
    
    static var shared = NetworkManager()
    
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    private init() {
        let sessionConfiguration = URLSessionConfiguration.default
        
        sessionConfiguration.timeoutIntervalForRequest = kRequestTimeout
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func call(ws: WebService) {
        guard isConnected else {
            ws.completion?(.failure(.noInternetConnection))
            
            return
        }
        
        createRequest(from: ws) { result in
            switch result {
            case .failure(let error):
                ws.completion?(.failure(.requestError(error: error)))
            case .success(let request):
                let dataTask = self.session.dataTask(with: request) { (data, response, error) in
                    guard error == nil else {
                        ws.completion?(.failure(.requestError(error: error)))
                        
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        ws.completion?(.failure(.noHttpResponse))
                        
                        return
                    }
                    
                    // 200 ok
                    if httpResponse.statusCode == 200 ||
                       httpResponse.statusCode == 201 {
                        guard let data = data else {
                            ws.completion?(.failure(.noData))
                            
                            return
                        }
                        
                        switch ws.acceptType {
                        case .json:
                            ws.completion?(.success(data))
                        }
                    // 204 no content
                    } else if httpResponse.statusCode == 204 {
                        ws.completion?(.success(nil))
                    // Other error
                    } else {
                        let statusError = WSError.statusError(code: httpResponse.statusCode)
                        
                        ws.completion?(.failure(statusError))
                    }
                }
                
                dataTask.resume()
            }
        }
    }
    
    // MARK: - Reachability
    
    func startReachability() {
        guard !reachabilityStarted else { return }
        
        reachabilityStarted = true
        
        try? reachability?.startNotifier()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    func stopReachability() {
        reachabilityStarted = false
        
        reachability?.stopNotifier()
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }
    
    var isConnected: Bool {
        guard let reachConnection = reachability else { return false }
        
        return reachConnection.connection != .none
    }
    
    @objc func reachabilityChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        let isReachable = reachability.connection != .none
        
        NotificationCenter.default.post(name: .reachabilityChanged, object: isReachable)
    }
    
    // MARK: - Private methods
    
    private func createRequest(from ws: WebService, completion: @escaping ((Result<URLRequest, CreateRequestError>) -> ())) {
        // Url
        guard let url = composeUrl(url: ws.url, params: ws.urlParameters) else {
            completion(.failure(.composingUrl))
            
            return
        }
        
        var request = URLRequest(url: url)
        
        // Method
        request.httpMethod = ws.method.rawValue
        
        // Body
        if let postBody = ws.postBody {
            request.httpBody = postBody
        }
        
        // Custom headers
        if let customHeaders = ws.customHeaders {
            for (header, value) in customHeaders {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        // Content-Type
        request.setValue(ws.contentType.rawValue, forHTTPHeaderField: ContentType.kHeaderContentType)
        
        // Accept-Type
        request.setValue(ws.acceptType.rawValue, forHTTPHeaderField: AcceptType.kHeaderAcceptType)
        
        completion(.success(request))
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
