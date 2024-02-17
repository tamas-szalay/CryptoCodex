import Foundation

struct Currency: Equatable, Hashable {
    let id: String
    let iconUrl: String
    let name: String
    let symbol: String
    let price: Decimal
    let changePercent24Hr: Decimal
    let supply: Decimal
    let volume24Hr: Decimal
    let marketCap: Decimal
}
