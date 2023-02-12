//
//  EndPoint.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/5/22.
//

import Foundation

protocol EndPoint {
    var basePath: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var postBody: [String: String]? { get }
    var urlParameters: [String: String]? { get }
    var customHeaders: [String: String]? { get }
}

enum HttpMethod: String {
    case post   = "POST"
    case get    = "GET"
    case delete = "DELETE"
    case put    = "PUT"
}

enum RequestError: Error {
    case invalidURL
    case noHttpResponse
    case noInternetConnection
    case parseError
    case statusError(code: Int)
    case unauthorized
    case unknown
}
