import Foundation

struct Currency: Equatable {
    let id: String
    let iconUrl: String
    let name: String
    let symbol: String
    let price: Decimal
    let changePercent24Hr: Decimal
    let supply: Decimal
}
