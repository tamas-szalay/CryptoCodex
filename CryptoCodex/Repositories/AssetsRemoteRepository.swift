import Combine

struct AssetsRemoteRepository: AssetsRepository {
    let httpConnection: HttpConnection

    func fetch(top: Int) -> AnyPublisher<AssetsResultDTO, CCError> {
        return httpConnection.sendRequest(method: .GET, endpoint: .assets, queryParameters: ["limit": String(top)], body: nil)
    }
    
    func fetchSingle(id: String) -> AnyPublisher<AssetResultDTO, CCError> {
        return httpConnection.sendRequest(method: .GET, endpoint: .asset(id), queryParameters: nil, body: nil)
    }
}
