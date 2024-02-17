import Combine
import Foundation

protocol CurrencyService {
    func getCurrencies() -> AnyPublisher<[Currency], CCError>
}

struct CurrencyServiceImpl: CurrencyService {
    let repository: AssetsRepository

    func getCurrencies() -> AnyPublisher<[Currency], CCError> {
        return repository.fetch(top: 10).map { response -> [Currency] in
            return response.data.map { Currency.from(asset: $0) }
        }.eraseToAnyPublisher()
    }
}


private extension Currency {
    static func from(asset: AssetDto) -> Currency {
        let icontUrl = "https://assets.coincap.io/assets/icons/\(asset.symbol.lowercased())@2x.png"
        return .init(id: asset.id, iconUrl: icontUrl, name: asset.name, symbol: asset.symbol, price: Decimal(string: asset.priceUsd) ?? 0, changePercent24Hr: Decimal(string: asset.changePercent24Hr) ?? 0, supply: Decimal(string: asset.supply) ?? 0)
    }
}
