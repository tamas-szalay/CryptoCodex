import Foundation
import Combine

enum HttpMethod: String {
    case GET, POST, PUT
}

protocol HttpConnection {
    func sendRequest<T: Codable>(
        method: HttpMethod,
        endpoint: ApiEndpoints,
        queryParameters: [String: String]?,
        body: Codable?
    ) -> AnyPublisher<T, CCError>
}

struct ResponseWithHeaders<T: Codable> {
    let response: T
    let headers: [AnyHashable: Any]
}

final class HttpConnectionImpl: HttpConnection {
    struct Configuration {
        let baseURL: URL
        let baseHeaders: [String: String]
        
        public init(baseURL: URL, baseHeaders: [String: String]) {
            self.baseURL = baseURL
            self.baseHeaders = baseHeaders
        }
        
        public static let `default` = Configuration(baseURL: URL(string: "https://api.coincap.io")!, baseHeaders: [:])
    }
    
    private let configuration: Configuration
    
    init(configuration: Configuration = .default) {
        self.configuration = configuration
    }
    
    func sendRequest<T: Codable>(
        method: HttpMethod,
        endpoint: ApiEndpoints,
        queryParameters: [String: String]?,
        body: Codable?
    ) -> AnyPublisher<T, CCError> {
        var url = URLComponents(url: configuration.baseURL.with(endpoint: endpoint), resolvingAgainstBaseURL: false)!
        url.queryItems = queryParameters?.map({ URLQueryItem(name: $0, value: $1)})
        
        return URLSession.shared.dataTaskPublisher(for: url.url!)
            .tryMap({ (data, response) throws -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch let error {
                    debugPrint("Parsing error: \(error)")
                    throw CCError.jsonParsingError
                }
            }).mapError({ error in
                if let exception = error as? CCError {
                    return exception
                }
                if let urlError = error as? URLError {
                    return .httpError(urlError.code.rawValue)
                }
                return .genericError("")
            })
        
            .eraseToAnyPublisher()
    }
}

extension URL {
    func with(endpoint: ApiEndpoints) -> URL {
        return appendingPathComponent(endpoint.rawValue)
    }
}
