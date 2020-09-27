//
//  HTTPOperation.swift
//  Repository
//
//  Created by Anshul Jain on 26/9/20.
//  Copyright © 2020 Anshul Jain. All rights reserved.
//

import Foundation

enum MovieNetworkAPIProvider: NetworkAPIProvider {
    
    case search(String)
    case details(String)
    
    var method: Method {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var parameters: [String : Any]? {
        var param: [String : Any] =  ["apikey": ServerEndPoint.apiKey]
        switch self {
        case .search(let query):
            param["s"] = query
            param["type"] = "movie"
        case .details(let id):
            param["i"] = id
        }
        return param;
    }
    
    var headers: [HTTPHeaderField : String]? {
        return [:]
    }
    
    var baseURL: URL {
        return ServerEndPoint.endPoint
    }
}

struct ServerEndPoint {
    static let endPoint = URL(string: "https://www.omdbapi.com/")!
    static let apiKey = "b9bd48a6"

}

typealias SearchResponseHandler = (Result<MovieSearchList,HTTPError>) -> Void
typealias MovieDetailsResponseHandler = (Result<MovieDetail,HTTPError>) -> Void

class Repository {
    private let httpOperationQueue = OperationQueue()
    var session = URLSession.shared;

    init(){
    }
    
    func searchMovies(query: String, completionHandler:@escaping SearchResponseHandler) {
        let api = MovieNetworkAPIProvider.search(query)
        fetechJSONData(api: api, resultHandler: completionHandler);
    }
    
    func fetechMoviedetails(imdbID: String, completionHandler:@escaping MovieDetailsResponseHandler) {
        let api = MovieNetworkAPIProvider.details(imdbID)
        fetechJSONData(api: api, resultHandler: completionHandler);
    }

    private func fetechJSONData<T:Decodable>(api :MovieNetworkAPIProvider, resultHandler: @escaping (Result<T, HTTPError>) -> Void)  {
         if let request = try? api.asURLRequest() {
            fetechData(fromRequest: request) { (result) in
                switch result {
                case .failure(let error):
                    resultHandler(.failure(error))
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        resultHandler(.success(result))
                    } catch {
                        resultHandler(.failure(HTTPError.jsonEncoding(error: error)))
                    }
                    break
                }
            }
        } else {
            fatalError("creating a URL request failed")
        }

    }

    private func fetechData(fromRequest request:URLRequest, result: @escaping (Result<Data, HTTPError>) -> Void)  {
        let operation = HTTPOperation(request: request, session: session, completionHandler: result)
        httpOperationQueue.addOperation(operation);
    }
}
