import Combine

protocol AssetsRepository {
    func fetch(top: Int) -> AnyPublisher<AssetsResultDTO, CCError>
    func fetchSingle(id: String) -> AnyPublisher<AssetResultDTO, CCError>
}
