//
//  HTTPOperation.swift
//  NetworkAPIProvider
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation

public struct HTTPHeaderField: RawRepresentable, Equatable, Hashable {
    
    public static let authentication = HTTPHeaderField(rawValue: "Authorization")
    public static let contentType = HTTPHeaderField(rawValue: "Content-Type")
    public static let acceptType = HTTPHeaderField(rawValue: "Accept")
    public static let acceptEncoding = HTTPHeaderField(rawValue: "Accept-Encoding")
    
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

}

public protocol NetworkAPIProvider {
    var method: Method { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var headers: [HTTPHeaderField: String]? { get }
    var baseURL: URL { get }
}

enum ContentType: String {
    case json = "application/json"
}

enum NetworkAPIProviderCodingKeys: String, CodingKey {
    case notValidJSON
}

enum NetworkError: Error {
    case jsonEncodingFailed(Error)
}

extension NetworkAPIProvider {
    
    internal func JSONParametersEncode(request: inout URLRequest, parameters: [String: Any]) throws {
      do {
          if JSONSerialization.isValidJSONObject(parameters) {
              request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
          } else {
              let error = DecodingError.dataCorrupted(DecodingError.Context(codingPath: [NetworkAPIProviderCodingKeys.notValidJSON], debugDescription: ""))
              throw NetworkError.jsonEncodingFailed(error)
          }
      } catch {
          throw NetworkError.jsonEncodingFailed(error)
      }
    }

    internal func URLEncodeParameters(request: inout URLRequest, parameters: [String: String]) throws {
      let query =  parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = query
            urlComponents.query = percentEncodedQuery
            request.url = urlComponents.url
        }
    }

    internal func parameterEncoding(request: inout URLRequest, parameters: [String: Any]) throws {
        switch method {
        case .get:
            if let param = parameters as?  [String: String] {
                try URLEncodeParameters(request: &request, parameters: param)
            }
        default:
            try JSONParametersEncode(request: &request, parameters: parameters)
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.value
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key.rawValue)
            }
        }
        // Parameters
        if let parameters = parameters {
            try parameterEncoding(request: &urlRequest, parameters: parameters)
        }
        
        return urlRequest
    }
}

public enum Method {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
    
    internal var value: String {
        switch self {
        case .connect:
            return "CONNECT"
        case .delete:
            return "DELETE"
        case .get:
            return "GET"
        case .head:
            return "HEAD"
        case .options:
            return "OPTIONS"
        case .patch:
            return "PATCH"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .trace:
            return "TRACE"
        }
    }
}

