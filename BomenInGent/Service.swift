import Foundation

class Service {
    
    enum Error: Swift.Error {
        case invalidJson(message: String)
        case missingJsonProperty(name: String)
        case missingResponseData
        case unexpectedStatusCode(code: Int, expected: Int)
        case other(Swift.Error)
    }
    
    static let shared: Service = {
        let url: URL = {
            
                let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
                let properties = NSDictionary(contentsOfFile: path)!
                return URL(string: properties["Base URL"] as! String)!
            
        }()
        return Service(url: url)
    }()
    
    private let url: URL
    private let session: URLSession
    
    init(url: URL, session: URLSession = URLSession(configuration: .ephemeral)) {
        self.url = url
        self.session = session
    }
    
    func loadDataTask(completionHandler: @escaping (Result<[Straatboom]>) -> Void) -> URLSessionTask {
        return session.dataTask(with: url) {
            data, response, error in
            
            // Wrap the completionHandler so it runs on the main queue.
            let completionHandler: (Result<[Straatboom]>) -> Void = {
                result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else {
                    completionHandler(.failure(.unexpectedStatusCode(code: response.statusCode, expected: 200)))
                    return
                }
            }
            guard let data = data else {
                completionHandler(.failure(.missingResponseData))
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json as? [[String: Any]] else {
                    completionHandler(.failure(.invalidJson(message: "data does not contain an array of objects")))
                    return
            }
            
            do {
                let straatBomen = try results.map {
                        try Straatboom(json: $0)
                    
                }
                completionHandler(.success(straatBomen))
            } catch let error as Error {
                print("ayy")
                completionHandler(.failure(error))
            } catch {
                fatalError("Unexpected error \(error)")
            }
        }
    }
}

