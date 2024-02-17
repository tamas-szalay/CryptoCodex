import SwiftUI

extension Font {
    public static func applicationBold(size: CGFloat) -> Font {
        return custom("Poppins-Bold", size: size)
    }
    
    public static func applicationRegular(size: CGFloat) -> Font {
        return custom("Poppins-Regular", size: size)
    }
}
