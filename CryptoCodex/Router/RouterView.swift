import SwiftUI

struct RouterView<Content: View>: View {
    @StateObject var router = Router(container: DIContainer.shared)
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route)
                }
        }.environmentObject(router)
    }
}

#Preview {
    RouterView {
        
    }.environmentObject(Router(container: DIContainer.shared))
}

