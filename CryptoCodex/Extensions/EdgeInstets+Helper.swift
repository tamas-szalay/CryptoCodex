import SwiftUI

extension EdgeInsets {
    
    static func all(_ value: CGFloat) -> EdgeInsets {
        return .init(top: value, leading: value, bottom: value, trailing: value)
    }
    
}
