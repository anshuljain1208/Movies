//
//  URLProtocolMock.swift
//  MoviesTests
//
//  Created by Anshul Jain on 27/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation

enum MockError: Error {
    case noResponseFound
}

let mockURL = URL(string: "https://www.mock.com/")!
extension HTTPURLResponse {
    static func badHTTPStatusResponse(_ code: Int) -> HTTPURLResponse {
       return  HTTPURLResponse(url: mockURL, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    static func successHTTPStatusResponse(url: URL = mockURL, statusCode: Int = 200 ) -> HTTPURLResponse {
       return  HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields:
        ["Content-Type": "application/json"])!
    }

}

public typealias MockResult = Result < (data:Data, response:HTTPURLResponse), Error >

public protocol MockDataProvider {
    func responseForRequest(request: URLRequest) -> MockResult?
}

extension MockDataProvider {
    public func canHandleRequest(request: URLRequest) -> Bool {
        if let _ = responseForRequest(request: request) {
            return true
        }
        return false
    }
}

class URLProtocolMock: URLProtocol {
    static var dataProviders = [MockDataProvider]()

    func providerForRequest(request: URLRequest) -> MockDataProvider? {
      print("providerForRequest")
        for provider in URLProtocolMock.dataProviders {
            if provider.canHandleRequest(request: request) {
                return provider
            }
        }
        return nil
    }

    static var configuration: URLSessionConfiguration  {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        return configuration
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override func startLoading() {
      print("startLoading")
        if let provider = providerForRequest(request: request) {
          print("provider")

            switch provider.responseForRequest(request: request) {
            case .success(let result):
                client?.urlProtocol(self, didReceive: result.response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                client?.urlProtocol(self, didLoad: result.data)
                self.client?.urlProtocolDidFinishLoading(self)
            case .failure(let error):
                client?.urlProtocol(self, didFailWithError: error)
            case .none:
                client?.urlProtocol(self, didFailWithError: MockError.noResponseFound)
            }
        } else {
            client?.urlProtocol(self, didFailWithError: MockError.noResponseFound)
        }

    }

    override func stopLoading() { }
}

extension URLProtocolMock: URLSessionDelegate {
    func URLSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
      print("URLProtocolMock URLSession didReceiveData")
        client?.urlProtocol(self, didLoad: data)
    }
    
    func URLSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("URLProtocolMock URLSession didCompleteWithError")
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

