//
//  WebService.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/5/22.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum AcceptType: String {
    static let kHeaderAcceptType = "Accept-Type"
    
    case json = "application/json"
}

enum ContentType: String {
    static let kHeaderContentType = "Content-Type"
    
    case json = "application/json"
}

enum WSError: Error {
    case noData
    case noHttpResponse
    case noInternetConnection
    case parseError
    case requestError(error: Error?)
    case statusError(code: Int)
    case unexpectedAcceptType
    case unexpectedRespType
    case unknown
}

struct WebService {
    let uuid = UUID().uuidString
    
    var url: String
    
    var method: HttpMethod = .get

    var acceptType: AcceptType = .json
    
    var contentType: ContentType = .json
    
    var postBody: Data?
    
    var urlParameters: [String: String]?
        
    private(set) var customHeaders: [String: String]?
    
    var completion: ((Result<Data?, WSError>) -> ())?
    
    mutating func addHeader(_ header: [String: String]) {
        if customHeaders == nil {
            customHeaders = [:]
        }
        
        for (key, value) in header {
            customHeaders![key] = value
        }
    }
    
    var debugDescription: [String: String] {
        var debugDesc = [String: String]()
    
        debugDesc["Url"] = self.url
        debugDesc["Method"] = self.method.rawValue
        
        if let urlParameters = self.urlParameters {
            var urlParametersStrArr = [String]()
            
            urlParameters.forEach { (key, value) in
                urlParametersStrArr.append("\(key)=\(value)")
            }
            
            debugDesc["UrlParams"] = urlParametersStrArr.joined(separator: " / ")
        } else {
            debugDesc["UrlParams"] = "None"
        }
        
        if let postBody = self.postBody, let postBodyStr = String(data: postBody, encoding: .utf8) {
            debugDesc["PostParams"] = postBodyStr
        } else {
            debugDesc["PostParams"] = "None"
        }
        
        if let customHeaders = self.customHeaders {
            var customHeadersStrArr = [String]()
            
            customHeaders.forEach { (key, value) in
                customHeadersStrArr.append("\(key)=\(value)")
            }
            
            debugDesc["CustomHeaders"] = customHeadersStrArr.joined(separator: " / ")
        } else {
            debugDesc["UrlParams"] = "None"
        }
        
        return debugDesc
    }
}

extension WebService {
    init(url: String, customHeaders: [String: String]) {
        self.url = url
        self.customHeaders = customHeaders
    }
}
