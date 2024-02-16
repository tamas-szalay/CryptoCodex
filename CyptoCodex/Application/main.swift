import Foundation
import UIKit
import SwiftUI

struct EmptyApp: App {
    var body: some Scene {
        WindowGroup {

        }
    }
}

if NSClassFromString("XCTestCase") != nil { // Unit Testing
    EmptyApp.main()
} else { // App
    CryptoCodexApp.main()
}

