import Combine
import Foundation

protocol CurrencyService {
    func getCurrencies() -> AnyPublisher<[Currency], CCError>
    func getCurrency(id: String) -> AnyPublisher<Currency, CCError>
}

struct CurrencyServiceImpl: CurrencyService {
    let repository: AssetsRepository

    func getCurrencies() -> AnyPublisher<[Currency], CCError> {
        return repository.fetch(top: 10).map { response -> [Currency] in
            return response.data.map { Currency.from(asset: $0) }
        }.eraseToAnyPublisher()
    }
    
    func getCurrency(id: String) -> AnyPublisher<Currency, CCError> {
        return repository.fetchSingle(id: id).map { Currency.from(asset: $0.data) }.eraseToAnyPublisher()
    }
}


private extension Currency {
    static func from(asset: AssetDto) -> Currency {
        let iconUrl = "https://assets.coincap.io/assets/icons/\(asset.symbol.lowercased())@2x.png"
        return .init(
            id: asset.id,
            iconUrl: iconUrl,
            name: asset.name,
            symbol: asset.symbol,
            price: Decimal(string: asset.priceUsd) ?? 0,
            changePercent24Hr: Decimal(string: asset.changePercent24Hr) ?? 0,
            supply: Decimal(string: asset.supply) ?? 0,
            volume24Hr: Decimal(string: asset.volumeUsd24Hr) ?? 0,
            marketCap: Decimal(string: asset.marketCapUsd) ?? 0
        )
    }
}
