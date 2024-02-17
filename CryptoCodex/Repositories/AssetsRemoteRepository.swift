import Combine

struct AssetsRemoteRepository: AssetsRepository {
    let httpConnection: HttpConnection

    func fetch(top: Int) -> AnyPublisher<AssetsResultDTO, CCError> {
        return httpConnection.sendRequest(method: .GET, endpoint: .assets, queryParameters: ["limit": String(top)], body: nil)
    }
}
