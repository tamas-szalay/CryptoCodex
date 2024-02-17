import Combine

protocol AssetsRepository {
    func fetch(top: Int) -> AnyPublisher<AssetsResultDTO, CCError>
}
