import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case currencyList
        case currencyDetails(Currency)
    }

    let container: DIContainer
    @Published var path: NavigationPath = NavigationPath()

    init(container: DIContainer) {
        self.container = container
    }

    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .currencyList:
            CurrencyListView(viewModel: CurrencyListViewModel(currencyService: container.resolve()))
        case .currencyDetails(let currency):
            CurrencyDetailsView(viewModel: CurrencyDetailsViewModel(currencyService: container.resolve(), currency: currency))
        }
    }

    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }

    func navigateBack() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
