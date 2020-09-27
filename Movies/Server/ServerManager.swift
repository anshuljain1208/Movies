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
    static let endPoint = URL(string: "http://www.omdbapi.com/")!
    static let apiKey = "b9bd48a6"

}

public typealias ServerResponseHandler = (Data?, Error?) -> Void
public typealias FetchResponseHandler = (Bool, Error?) -> Void

class Repository {
    static let shared = Repository()
    var session = URLSession.shared;
    private let httpOperationQueue = OperationQueue()

    init(){
    }
    
    // MARK: - Server Request
    func searchMovies(query: String, completionHandler:@escaping FetchResponseHandler) {
        let api = MovieNetworkAPIProvider.search(query)
        if let request = try? api.asURLRequest() {
            
        }
    }
    
    private func fetechJsonDataFromURL(url:URL, completeionHandler:@escaping ServerResponseHandler)  {
        let operation = HTTPOperation(url: url, session: URLSession.shared, completionHandler: {
            (data, error) in
            if let jsonData = data {
                completeionHandler(jsonData,nil)
            }
            else if error != nil {
                completeionHandler(nil,error)
            }
            else {
                fatalError("This should never be reached issues with HTTPOperation")
            }
        })
        httpOperationQueue.addOperation(operation);
    }
}
