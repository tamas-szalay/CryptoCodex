
import SwiftUI

struct NavigationTitle : View {
    let text: String
    
    var body: some View {
        Text(text).foregroundStyle(.fgDefault).font(.applicationBold(size: 32)).padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
    }
}

