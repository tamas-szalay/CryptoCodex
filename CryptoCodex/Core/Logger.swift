import OSLog

extension Logger {
    
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let networking = Logger(subsystem: subsystem, category: "networking")
}
