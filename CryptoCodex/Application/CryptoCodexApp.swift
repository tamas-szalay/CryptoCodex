import SwiftUI

struct CryptoCodexApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView {
                CurrencyListView(viewModel: CurrencyListViewModel(currencyService: DIContainer.shared.resolve()))
            }
        }
    }
}
