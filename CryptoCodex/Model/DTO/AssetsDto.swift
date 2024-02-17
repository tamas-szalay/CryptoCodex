
struct AssetsResultDTO: Codable {
    let data: [AssetDto]
}

struct AssetResultDTO: Codable {
    let data: AssetDto
}

struct AssetDto: Codable {
    let id: String
    let rank: String
    let symbol: String
    let name: String
    let supply: String
    let priceUsd: String
    let changePercent24Hr: String
    let volumeUsd24Hr: String
    let marketCapUsd: String
}
