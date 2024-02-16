
class DIContainer {

    static let shared: DIContainer = DIContainer()

    private var instances = [String: Any]()

    
    private init() {
        
    }

    private func register<T>(_ instance: T) {
        let key = String(describing: T.self)
        instances[key] = instance
    }
    
    private func registerFactory<T>(_ factory: @escaping () -> T) {
        let key = String(describing: T.self)
        instances[key] = factory
    }

    func resolve<T>() -> T {
        let key = String(describing: T.self)

        if let instance = instances[key] as? T {
            return instance
        } else if let factory = instances[key] as? () -> T {
            return factory()
        }

        fatalError("No instance registered for \(key)")
    }
}
