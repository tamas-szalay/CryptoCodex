import Combine
import Foundation
@testable import CryptoCodex

struct MockHttpConnection: HttpConnection {

    enum MockResponse {
        case success(Data)
        case failure(CCError)
    }

    typealias MockCallback = (_ path: String, _ method: String, _ queryParameters: [String: String]?) -> MockResponse

    let mockCallback: MockCallback

    func sendRequest<T: Codable>(
        method: CryptoCodex.HttpMethod,
        endpoint: CryptoCodex.ApiEndpoints,
        queryParameters: [String: String]?,
        body: Codable?
    ) -> AnyPublisher<T, CCError> {
        switch mockCallback(endpoint.asPathComponent, method.rawValue, queryParameters) {
        case .success(let response):
            let data = try! JSONDecoder().decode(T.self, from: response)
            return Just(data)
                .setFailureType(to: CCError.self)
                .eraseToAnyPublisher()
        case .failure(let exception):
            return Fail(error: exception).eraseToAnyPublisher()
        }
    }
}
