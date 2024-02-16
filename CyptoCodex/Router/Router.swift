import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case currencyList
        case currencyDetails
    }

    let container: DIContainer
    @Published var path: NavigationPath = NavigationPath()

    init(container: DIContainer) {
        self.container = container
    }

    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .currencyList:
            CurrencyListView()
        case .currencyDetails:
            CurrencyDetailsView()
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
