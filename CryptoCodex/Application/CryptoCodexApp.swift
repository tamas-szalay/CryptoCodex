import SwiftUI

struct CryptoCodexApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView {
                CurrencyListView(viewModel: CurrencyViewModel(currencyService: DIContainer.shared.resolve()))
            }
        }
    }
}
