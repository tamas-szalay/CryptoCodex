
class DIContainer {

    static let shared: DIContainer = DIContainer()

    private var instances = [String: Any]()

    
    private init() {
        register(HttpConnection.self, HttpConnectionImpl())
        registerFactory(AssetsRepository.self) { resolver in
            return AssetsRemoteRepository(httpConnection: resolver.resolve())
        }
        registerFactory(CurrencyService.self) { resolver in
            return CurrencyServiceImpl(repository: resolver.resolve())
        }
    }

    private func register<T>(_ serviceType: T.Type, _ instance: T) {
        let key = String(describing: T.self)
        instances[key] = instance
    }
    
    private func registerFactory<T>(_ serviceType: T.Type, _ factory: @escaping (DIContainer) -> T) {
        let key = String(describing: T.self)
        instances[key] = factory
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)

        if let instance = instances[key] as? T {
            return instance
        } else if let factory = instances[key] as? (DIContainer) -> T {
            return factory(self)
        }

        fatalError("No instance registered for \(key)")
    }
}
