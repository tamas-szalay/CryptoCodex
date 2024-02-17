enum ApiEndpoints {
    case assets
    case asset(String)
    
    var asPathComponent: String {
        switch self {
        case .assets:
            return "v2/assets"
        case .asset(let id):
            return "v2/assets/" + id
        }
    }
}
