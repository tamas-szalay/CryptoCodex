import SwiftUI

struct CryptoCodexApp: App {
    @StateObject var router = Router(container: DIContainer.shared)

    var body: some Scene {
        WindowGroup {
            RouterView {
                router.view(for: .currencyList)
            }.environmentObject(router)
        }
    }
}
